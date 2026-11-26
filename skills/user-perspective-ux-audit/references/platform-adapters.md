# 多平台盲测执行适配指南 (Multi-Platform Blind Execution Adapters)

本指南规范如何在 **Web 桌面端**、**移动端 H5 / 响应式网页** 以及 **原生桌面客户端 / Electron / Tauri** 三种形态下启动盲测员子代理，确保全平台都能做到“零源码接触、真实画面取证、真实交互验证”。

---

## 1. Web 桌面端应用适配 (Web Desktop)

### 环境准备（主控 Agent 执行）
1. 若用户已提供正在运行的 URL（如 `http://localhost:3000` 或测试环境域名），直接使用该裸 URL，**主控无需提前用 `curl` 抓取页面内容**。
2. 若服务尚未启动：主控 Agent 自行查看 `package.json` / 启动脚本并在后台拉起开发服务器（`IsDaemon: true`），提取出最终监听的 `http://localhost:<PORT>`。
3. **保密隔离**：主控在启动服务过程中看到的任何项目名称、框架信息、路由列表，**一律不得写入发给 `browser` 子代理的 Prompt**。

### 启动盲测员子代理
- 调用 `invoke_subagent`：
  - `TypeName`: `"browser"`
  - `Model`: `"flash"`（遵循内置 `browser` 子代理默认规范，除非用户另有指定）
  - `Role`: `"Blind First-Time User Tester"`（复检时用新角色名，如 `"Fresh Blind User Retester"`）
- **视口要求**：阶段一默认在标准桌面视口（建议 `1440×900` 或 `1280×800`）截图取证，并检查宽屏下的内容最大宽度与对齐。
- **事实核验**：主控收到 `browser` 子代理回复后，必须对照系统自动附加的 `BROWSER_HOST_FACTS` 消息核验实际访问的站点与最新截图路径；向用户报告或写入 Artifact 时，将关键证据截图复制到当前会话的 `<ArtifactDir>` 下引用。

---

## 2. 移动端 H5 / 响应式网页适配 (Mobile H5 & Responsive)

### 何时启用
- 被测对象本身是移动端 H5、小程序 WebView 页面、移动端优先（Mobile-First）应用；
- 或者常规面向用户的 Web 产品需要检验**双端响应式体验**。

### 执行策略（通过 `browser` 子代理）
1. **阶段一双视口对比盲测**：
   - 先在桌面视口（`1440×900`）完成首屏截图与 5 秒认知测试（纯移动端专属 H5 可直接从手机视口开始）。
   - 随后将浏览器视口切换至主流手机尺寸（标准基准：`390×844` iPhone 尺寸；必要时补测小屏 `375×667` 或平板 `768×1024`），刷新或观察自适应重排结果并截图。
2. **移动端专项挑刺重点**：
   - **横向溢出零容忍**：在手机视口下向右拖动或检查 `document.documentElement.scrollWidth > window.innerWidth`，凡出现页面级横向滚动条直接判为 `P1 Major`。
   - **触控热区与防误触**：主导航、关闭按钮、列表操作项点击区域是否过小（小于 `44×44px`）或上下紧贴极易误触？
   - **移动端导航抽屉联动（阶段二必测）**：点击汉堡菜单（`☰`）展开导航抽屉 → 点击某个菜单项跳转页面后，**导航抽屉是否自动收起**？（常见 Bug：页面跳过去了，半屏抽屉还死死挡在前面）。
   - **底部固定栏遮挡**：底部吸底操作栏（Sticky Bar / TabBar）是否遮挡了页面最底部的列表最后一项或表单提交按钮？

---

## 3. 原生桌面客户端 / Electron / Tauri 应用适配 (Desktop & Electron)

对于桌面软件（WinForms / WPF / Qt / PyQt / Tauri / Electron / Flutter Desktop 等），优先根据架构选择最贴近真实用户所见的路径：

### 路径 A：真实桌面窗口盲测（推荐，完整覆盖原生窗口边框、系统菜单与 IPC 功能）

1. **主控 Agent 拉起窗口并锁定标识**：
   - 主控在后台启动桌面程序（若用户已打开程序则跳过启动）。
   - Windows 环境下运行本 Skill 自带的窗口枚举命令，确认目标窗口已正常显示并记录其 `ProcessId` 或 `WindowTitle`：
     ```powershell
     powershell -NoProfile -ExecutionPolicy Bypass -File "<Skill目录>/scripts/capture_window.ps1" -ListWindows
     ```
2. **启动受控纯净盲测子代理（Clean-Room `self` Subagent）**：
   - 调用 `invoke_subagent`：
     - `TypeName`: `"self"`
     - `Role`: `"Blind Desktop User Tester"`
   - **给桌面盲测员下达严格沙盒红线（必须原样包含在 Prompt 中）**：
     ```text
     【桌面盲测沙盒铁律】：
     1. 你扮演第一次打开该桌面软件的普通用户。目标窗口 PID 为 <PID>（或窗口标题包含 "<Title>"）。
     2. 严禁对项目工作区执行 ls / Get-ChildItem / rg / grep / read_file 读取任何源代码、README、配置文件或资源目录！
     3. 你只能执行以下两类动作来感知和测试软件：
        a) 调用截图脚本获取目标窗口当前真实画面，并用 read_file 查看生成的 PNG 截图文件：
           powershell -NoProfile -ExecutionPolicy Bypass -File "<Skill目录>/scripts/capture_window.ps1" -ProcessId <PID> -OutFile "<ArtifactDir>/ux_screenshots/step_01.png"
        b) 通过 UI 自动化（如 Windows UIAutomation / SendKeys / 坐标点击脚本，或应用支持的 Playwright Electron 驱动）模拟真实用户的鼠标点击、键盘输入、窗口拉伸与快捷键操作，每步操作后再次截图观察界面变化。
     ```
3. **跨操作系统桌面截图脚本（macOS / Linux）**：
   - 直接调用本 Skill 自带的跨平台脚本 `[capture_window.sh](../scripts/capture_window.sh)`：
     ```bash
     # 枚举当前可见窗口
     bash "<Skill目录>/scripts/capture_window.sh" --list
     # 捕获指定标题窗口截图（自动适配 macOS screencapture / Linux maim, import, grim）
     bash "<Skill目录>/scripts/capture_window.sh" --title "<WindowTitle>" --out "<ArtifactDir>/ux_screenshots/step_01.png"
     ```

### 路径 B：Electron / Tauri 混合应用的渲染层辅助审查

- 如果被测软件是 Electron / Tauri 应用，且开发模式下同时暴露了本地前端地址（如 `http://localhost:5173`），注意区分：
  - 若页面高度依赖预加载脚本（`window.electronAPI` / Tauri `invoke`），直接用普通浏览器打开会报错失真——此时**必须走路径 A**（或使用 Playwright 的 `_electron.launch()` 连接真实 Electron 实例截图交互）。
  - 若前端支持浏览器独立运行，可用 `browser` 子代理快速辅助检查响应式排版，但**最终窗口默认尺寸、自定义无边框标题栏（最小化/最大化/关闭按钮热区）、系统托盘或原生文件弹窗联动**仍需在真实桌面窗口核验。

---

## 4. 桌面端专属体验与联动检查补充项

审查原生桌面 / Electron 应用时，在通用清单之外额外核查：
1. **首次启动窗口尺寸与位置**：默认窗口是否过小导致内容挤作一团，或在超分屏（125% / 150% / 200% DPI 缩放）下字体发虚、控件错位？屏幕居中显示还是贴在左上角边缘？
2. **窗口自由拉伸联动**：将窗口拉到最窄/最大化/还原时，内部左右分栏（Split Pane）、底部状态栏和表格列宽是否平滑跟随，还是出现大片死白或按钮被裁切不可点？
3. **桌面快捷键与焦点直觉**：`Ctrl+S`（保存）、`Ctrl+F`（查找）、`Esc`（关闭弹窗）、`Enter`（确认）、`Tab`（表单切换焦点）是否符合桌面软件用户肌肉记忆？
4. **多窗口 / 设置子窗口联动**：在独立的“首选项/设置窗口”修改配置后，主窗口界面是否即时生效，还是必须重启整个客户端才生效？
