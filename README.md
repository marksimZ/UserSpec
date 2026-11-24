# UserSpec — 纯用户视角软件界面与体验审查 Skill

`user-perspective-ux-audit` 是一个专为 Google Antigravity 设计的用户体验盲测审查 Skill。它指挥模型彻底褪去“开发者滤镜”，以**完全没见过项目的真实新用户视角**对软件界面进行分阶段体检、对齐修改并闭环复测。

---

## 核心特性

1. **主从双角色物理隔离（真·零先验盲测）**
   - **主控 Agent**：负责启动服务、管理进度、与你确认问题清单并修改代码，**绝不向盲测员剧透任何业务背景或 README 内容**。
   - **盲测员 Subagent**：只接收裸 URL 或桌面窗口句柄，严禁读取项目源码，完全凭真实画面截图与键鼠交互体验软件。
   - **全新盲测员复检**：第一阶段改完代码后，强制启用全新的子代理重新做“第一眼测试”，避免旧上下文记忆污染。

2. **强制两阶段门禁（Gatekept 2-Stage Workflow）**
   - **阶段一（第一印象 · 观感 · 易读性）**：5 秒直觉盲猜测试、视觉主次与排版工艺、响应式视口、严抓“开发腔/枚举值/黑话外露”、登录墙与新用户注册门槛体验。
   - **阶段门禁**：先向你列出问题清单 → 你拍板改哪些 → 主控改代码 → 新盲测员复检过关 → **才解锁阶段二**。
   - **阶段二（流畅度 · 多界面联动性）**：即时反馈、防连点、防丢稿、无死胡同导航，以及全程**禁用 F5 刷新**的 6 大跨页面数据/状态同步测试链路。

3. **全平台软件支持**
   - **Web 桌面端应用**（内置 `browser` 子代理）
   - **移动端 H5 / 响应式网页**（双视口对比：`1440×900` 桌面端 + `390×844` 手机端）
   - **原生桌面客户端 / Electron / Tauri**（受控纯净子代理 + 自带高分屏 DPI 感知窗口截图脚本 `scripts/capture_window.ps1`）

---

## 目录结构

```text
UserSpec/
├── .agents/
│   └── skills.json                                   # 工作区自动发现声明
├── skills/
│   └── user-perspective-ux-audit/
│       ├── SKILL.md                                  # 主编排指令、角色隔离纪律与子代理 Prompt 模板
│       ├── references/
│       │   ├── phase1-first-impression-checklist.md  # 阶段一：5秒测试、观感工艺、去开发腔易读性细则
│       │   ├── phase2-fluency-and-linkage-matrix.md  # 阶段二：流畅度指标与跨界面状态联动矩阵
│       │   ├── platform-adapters.md                  # Web / 移动端 H5 / 原生桌面与 Electron 执行适配
│       │   └── audit-report-template.md              # 阶段一与阶段二标准化诊断报告模板
│       └── scripts/
│           └── capture_window.ps1                    # 零依赖 Windows 高分屏桌面窗口枚举与截图工具
└── README.md
```

---

## 安装与使用方式

克隆本仓库到本地：

```bash
git clone https://github.com/marksimZ/UserSpec.git
```

当你需要对某个目标软件项目进行审查时，任选以下一种方式即可：

### 方式 A：在目标项目中按需引用（推荐，单点维护自动同步）
在目标项目的 `.agents/skills.json`（或全局 `~/.gemini/config/skills.json`）中指向本仓库的 `skills` 目录：
```json
{
  "entries": [
    {
      "path": "/path/to/UserSpec/skills"
    }
  ]
}
```

### 方式 B：复制到目标项目跟版控共享
将 `skills/user-perspective-ux-audit` 文件夹复制到目标项目的 `.agents/skills/user-perspective-ux-audit`。

### 触发对话示例
- *“用纯用户视角帮我审查一下当前项目的界面和使用体验，先看第一印象。”*
- *“服务跑在 `http://localhost:5173`，按新用户视角做一轮 UI 观感、易读性和多页面联动审查。”*
- *“我已经打开了桌面客户端窗口，帮我从零背景用户角度审查它的首屏观感和各界面联动。”*
