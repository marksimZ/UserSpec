<#
.SYNOPSIS
    DPI-aware Windows desktop window enumerator and screenshot helper for blind UX auditing.

.DESCRIPTION
    Supports listing visible top-level application windows (-ListWindows) and capturing crisp,
    DPI-accurate PNG screenshots of a specific target window (by -ProcessId, -ProcessName, or
    -WindowTitle) or the entire primary screen (-FullScreen) without requiring third-party packages.

.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File .\capture_window.ps1 -ListWindows

.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File .\capture_window.ps1 -ProcessId 12345 -OutFile "C:\temp\shot1.png"

.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File .\capture_window.ps1 -WindowTitle "MyApp" -OutFile "C:\temp\shot2.png"
#>

param(
    [switch]$ListWindows,
    [int]$ProcessId = 0,
    [string]$ProcessName = "",
    [string]$WindowTitle = "",
    [string]$OutFile = "",
    [switch]$FullScreen,
    [int]$DelayMs = 350
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$Win32Source = @"
using System;
using System.Runtime.InteropServices;

public static class UxAuditWin32 {
    [StructLayout(LayoutKind.Sequential)]
    public struct RECT {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    [DllImport("user32.dll")]
    public static extern bool SetProcessDPIAware();

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool IsIconic(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("dwmapi.dll")]
    public static extern int DwmGetWindowAttribute(IntPtr hwnd, int dwAttribute, out RECT pvAttribute, int cbAttribute);

    public static RECT GetAccurateWindowBounds(IntPtr hWnd) {
        RECT rect;
        int DWMWA_EXTENDED_FRAME_BOUNDS = 9;
        int hr = DwmGetWindowAttribute(hWnd, DWMWA_EXTENDED_FRAME_BOUNDS, out rect, Marshal.SizeOf(typeof(RECT)));
        if (hr == 0 && (rect.Right - rect.Left) > 0 && (rect.Bottom - rect.Top) > 0) {
            return rect;
        }
        GetWindowRect(hWnd, out rect);
        return rect;
    }
}
"@

Add-Type -TypeDefinition $Win32Source -Language CSharp
[void][UxAuditWin32]::SetProcessDPIAware()

if ($ListWindows) {
    $windows = @(Get-Process | Where-Object {
        $_.MainWindowHandle -ne [IntPtr]::Zero -and
        [UxAuditWin32]::IsWindowVisible($_.MainWindowHandle) -and
        -not [string]::IsNullOrWhiteSpace($_.MainWindowTitle)
    } | ForEach-Object {
        $rect = [UxAuditWin32]::GetAccurateWindowBounds($_.MainWindowHandle)
        [PSCustomObject]@{
            ProcessId   = $_.Id
            ProcessName = $_.ProcessName
            WindowTitle = $_.MainWindowTitle
            Left        = $rect.Left
            Top         = $rect.Top
            Width       = ($rect.Right - $rect.Left)
            Height      = ($rect.Bottom - $rect.Top)
            IsMinimized = [UxAuditWin32]::IsIconic($_.MainWindowHandle)
        }
    })
    if ($windows.Count -eq 0) {
        Write-Output "[]"
    } else {
        ConvertTo-Json -InputObject $windows -Depth 3
    }
    exit 0
}

if ([string]::IsNullOrWhiteSpace($OutFile)) {
    throw "Parameter -OutFile is required when capturing a screenshot."
}

$outDir = Split-Path -Parent $OutFile
if (-not [string]::IsNullOrWhiteSpace($outDir) -and -not (Test-Path -LiteralPath $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

if ($FullScreen) {
    Start-Sleep -Milliseconds $DelayMs
    $screenBounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bmp = New-Object System.Drawing.Bitmap($screenBounds.Width, $screenBounds.Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    try {
        $graphics.CopyFromScreen($screenBounds.Location, [System.Drawing.Point]::Empty, $screenBounds.Size)
        $bmp.Save($OutFile, [System.Drawing.Imaging.ImageFormat]::Png)
    } finally {
        $graphics.Dispose()
        $bmp.Dispose()
    }
    Write-Output ([PSCustomObject]@{
        Mode   = "FullScreen"
        Path   = (Resolve-Path -LiteralPath $OutFile).Path
        Width  = $screenBounds.Width
        Height = $screenBounds.Height
    } | ConvertTo-Json)
    exit 0
}

$targetProc = $null

if ($ProcessId -gt 0) {
    $targetProc = Get-Process -Id $ProcessId -ErrorAction SilentlyContinue
} elseif (-not [string]::IsNullOrWhiteSpace($ProcessName)) {
    $targetProc = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue |
        Where-Object { $_.MainWindowHandle -ne [IntPtr]::Zero } |
        Select-Object -First 1
} elseif (-not [string]::IsNullOrWhiteSpace($WindowTitle)) {
    $targetProc = Get-Process | Where-Object {
        $_.MainWindowHandle -ne [IntPtr]::Zero -and
        $_.MainWindowTitle -like "*$WindowTitle*"
    } | Select-Object -First 1
} else {
    throw "Specify one of -ProcessId, -ProcessName, -WindowTitle, -FullScreen, or -ListWindows."
}

if ($null -eq $targetProc -or $targetProc.MainWindowHandle -eq [IntPtr]::Zero) {
    throw "Target window not found or has no visible MainWindowHandle."
}

$hWnd = $targetProc.MainWindowHandle
if ([UxAuditWin32]::IsIconic($hWnd)) {
    # SW_RESTORE = 9
    [void][UxAuditWin32]::ShowWindow($hWnd, 9)
    Start-Sleep -Milliseconds 250
}

[void][UxAuditWin32]::SetForegroundWindow($hWnd)
if ($DelayMs -gt 0) {
    Start-Sleep -Milliseconds $DelayMs
}

$rect = [UxAuditWin32]::GetAccurateWindowBounds($hWnd)
$width = $rect.Right - $rect.Left
$height = $rect.Bottom - $rect.Top

if ($width -le 0 -or $height -le 0) {
    throw "Invalid window bounds (${width}x${height}) for PID $($targetProc.Id)."
}

$bitmap = New-Object System.Drawing.Bitmap($width, $height)
$gfx = [System.Drawing.Graphics]::FromImage($bitmap)
try {
    $gfx.CopyFromScreen($rect.Left, $rect.Top, 0, 0, (New-Object System.Drawing.Size($width, $height)))
    $bitmap.Save($OutFile, [System.Drawing.Imaging.ImageFormat]::Png)
} finally {
    $gfx.Dispose()
    $bitmap.Dispose()
}

Write-Output ([PSCustomObject]@{
    Mode        = "Window"
    ProcessId   = $targetProc.Id
    ProcessName = $targetProc.ProcessName
    WindowTitle = $targetProc.MainWindowTitle
    Path        = (Resolve-Path -LiteralPath $OutFile).Path
    Left        = $rect.Left
    Top         = $rect.Top
    Width       = $width
    Height      = $height
} | ConvertTo-Json)
