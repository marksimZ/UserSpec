<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/logo-dark.png">
    <img src="assets/logo.png" width="210" alt="Specs —— 零背景真实新用户审查官">
  </picture>
</p>

<h1 align="center">UserSpec</h1>

<p align="center">
  <em>没看过你的 README。只给首屏五秒钟。绝不替你按 F5。</em>
</p>

<p align="center">
  <a href="https://github.com/marksimZ/UserSpec/stargazers"><img src="https://img.shields.io/github/stars/marksimZ/UserSpec?style=flat-square&color=111111&label=stars" alt="Stars"></a>
  <img src="https://img.shields.io/badge/modes-lite%20%C2%B7%20full%20%C2%B7%20savage-111111?style=flat-square" alt="支持三档模式">
  <img src="https://img.shields.io/badge/surfaces-Web%20%C2%B7%20Mobile%20H5%20%C2%B7%20Desktop-111111?style=flat-square" alt="全平台支持">
  <img src="https://img.shields.io/badge/works%20with-Antigravity%20%C2%B7%20Claude%20%C2%B7%20Codex%20%C2%B7%20Cursor-111111?style=flat-square" alt="多代理兼容">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-111111?style=flat-square" alt="MIT 开源协议"></a>
</p>

<p align="center">
  <sub><a href="README.md">English</a> &middot; <strong>简体中文</strong> &middot; <a href="INSTALL.md">安装指南</a></sub>
</p>

---

你见过他。圆框平光镜，手里端着刚买的温热咖啡，浏览器里还开着三十个别的标签页。

他不知道你的项目英文代号是什么意思，没读过你的 `README.md`，不知道设置入口藏在左下角头像二级菜单里，更不会在你的首页仪表盘忘了更新数字时乖乖替你按 `F5` 刷新。给他五秒钟看你的首屏——只要他需要眯起眼睛猜用途、找按钮，或者看到一行裸露的 `STATUS_PENDING`，他就会直接关掉页面走人。

**UserSpec 把他装进了你的 AI 代理里。**

---

## 为什么普通 AI 测不出真实用户体验问题？

当你直接对普通编码 AI 说*“从用户角度帮我看看界面体验”*时，它干的第一件事就是去读你的 `README.md`、`package.json` 和路由源码。**在它读完代码的那一秒，盲测就已经彻底失效了**——它立刻染上了和你一模一样的“开发者滤镜（知识的诅咒）”：

| 偷看过源码的 AI 会怎么夸 | **Specs**（纯零背景新用户）看到的真实画面 |
| :--- | :--- |
| *“整体界面采用极简现代化工作台设计，结构清晰！”* | *“首屏四个同样刺眼的蓝色按钮抢视线，中间一张惨白表格写着‘暂无数据’。这到底是干嘛的软件？”* |
| *“状态列正确绑定并展示了任务枚举状态。”* | *“给活人看的界面上为什么直接印着 `TASK_IN_PROGRESS` 和 `2026-11-26T02:55:28.000Z`？”* |
| *“新建记录功能正常，刷新页面后统计数据更新。”* | *“我在弹窗里明明新建成功了，切回首页待办数还是 `0`。我只会觉得你没保存上，然后再点三次提交。”* |
| *“登录鉴权页面表单校验正常。”* | *“连一句这软件能干嘛都不肯告诉我，上来就让我交出手机号和密码注册？”* |

---

## 核心工作流：物理盲测隔离墙 + 两阶段硬门禁

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/workflow-dark.svg">
    <img src="assets/workflow-light.svg" width="900" alt="UserSpec 零剧透盲测墙与两阶段门禁工作流">
  </picture>
</p>

1. **零剧透双角色物理隔离（Coordinator vs. Blind Subagent）**
   主控 Agent 负责拉起本地服务或桌面窗口，把 `README` 和源码烂在自己肚子里，**只向独立的盲测子代理传递一个裸 URL 或窗口 PID**。盲测员被严格禁止读取任何仓库文件，只能凭真实渲染截图与键鼠操作来认识你的软件。
2. **阶段一：5 秒第一印象、观感与易读性体检（禁止深点功能）**
   在乱点深层增删改之前，Specs 先截取桌面端（`1440×900`）与手机端（`390×844`）双视口（或原生客户端窗口），原话回答四问：*我猜这是干嘛的？给谁用的？第一步该点哪？哪里让我第一眼想关页面？* 随后逐项挑刺**观感工艺**（层级、对齐、留白、粗糙原生控件）与**去开发腔易读性**（枚举值、`undefined`、UUID、生硬术语一票否决）。
   - *遇到登录墙怎么办？* 先审查登录页有没有在索要账号前讲清产品价值，再按真实新用户走“游客试用 / 自助注册”检验转化门槛；若遇到验证码、真实短信/邮箱 OTP 或强制第三方登录，立即安全停机（`AUTH_REQUIRED`）向你索要测试账号，绝不违规硬绕。
3. **🔒 阶段一强制门禁（你拍板 → 改代码 → 全新盲测员复检）**
   阶段二默认锁死。主控先向你列出分级问题清单（`P0 Blocker` / `P1 Major` / `P2 Minor`），由你拍板改哪些；改完代码后，强制启动一个**全新的盲测子代理**（绝不复用已经有记忆的旧子代理！）重新做第一眼验收，通过后才解锁阶段二。
4. **阶段二：交互流畅度与禁用 `F5` 的多界面联动测试**
   首屏过关后，Specs 不看说明书实测核心任务流：点击即时反馈、零布局跳动（CLS）、**快速连点重复提交测试**、表单报错防清空/防丢稿、死胡同页面排查，并在**全程严禁按 `F5` 硬刷新**的前提下跑通至少 **5 条跨界面状态联动链路**：
   - **增删改 → 全局概览联动**：在 A 页面/弹窗增删改数据 → 切到 B 页面检查首页统计卡片、图表、侧边栏数字角标与全局搜索是否实时同步。
   - **主从详情 ↔ 关联下拉框同步**：在设置页重命名/停用分类或标签 → 检查其他页面的筛选下拉框与卡片标签是否残留旧缓存。
   - **导航往返与上下文保持**：列表搜索 + 筛选 + 翻到第 2 页 → 点进详情 → 点击界面返回与浏览器后退，检查筛选条件、页码与菜单高亮是否保持。
   - **全局设置跨组件广播**：切换深浅色主题、语言或头像昵称 → 检查二级页面、弹窗、浮层与图表是否一致生效、有无样式撕裂。
   - **数据生命周期边界流转**：`0 条空状态 → 新建第 1 条 → 50 字超长标题与特殊符号 → 全部删空回 0 条` 的全链路界面闭合。

---

## 三档严格度模式与专属个性签名落款

调用时可随时指定审查档位：

| 档位 | 行为逻辑 |
| :--- | :--- |
| **`lite`** | **快速扫一眼。** 仅对当前入口屏做 5 秒直觉 + 观感/开发腔快检，直接给诊断结论，不改代码。 |
| **`full`** | **默认档。** 完整盲测子代理物理隔离 + 阶段一确认修复与新盲测员复检硬门禁 + 阶段二流畅度与 5+ 条无 `F5` 跨页联动实测。 |
| **`savage`** | **毒舌秒退档。** 包含 `full` 全部规则，外加零容忍挑刺：连 `2px` 对齐错位、拖沓动画、多余按钮都不放过，并在修补前直接质疑“这个让人困惑的控件是不是干脆删掉更好”。 |

每一次审查回复末尾都会附上 **Specs 的两行专属签名落款**，一眼看清门禁状态、盲测纯粹度与未测风险边界：

```markdown
---
👓 **UserSpec** (`full`) · Gate: `PHASE 1 LOCKED 🔒`
*“没看过你的 README。只给首屏五秒钟。绝不替你按 F5。”*
**盲测范围与未测项**：盲测员零源码接触 · 已核验：`/login`、`/dashboard`（`1440×900`、`390×844`） · 待解锁：阶段二联动测试（需先完成 P1-01、P1-02 修复并通过全新盲测复检）
```

---

## 快速安装

### Antigravity

克隆仓库后，在目标项目的 `.agents/skills.json`（或全局 `~/.gemini/config/skills.json`）中指向 `skills` 目录，一处维护处处生效：

```json
{
  "entries": [
    { "path": "/path/to/UserSpec/skills" }
  ]
}
```

### Claude Code

```text
/plugin marketplace add marksimZ/UserSpec
/plugin install userspec@userspec
```

### Codex CLI & IDE 扩展

```powershell
New-Item -ItemType Directory -Force -Path "$HOME/.agents/skills" | Out-Null
git clone https://github.com/marksimZ/UserSpec.git "$env:TEMP\UserSpec"
Copy-Item -Recurse -Force "$env:TEMP\UserSpec\skills\user-perspective-ux-audit" "$HOME/.agents/skills/user-perspective-ux-audit"
```

### Cursor、Windsurf、Cline、Copilot 等其他代理

直接挂载 `skills/user-perspective-ux-audit/SKILL.md`，或将精简规则版 [`adapters/AGENTS.md`](adapters/AGENTS.md) 复制到目标项目根目录。完整跨平台安装命令见 **[INSTALL.md](INSTALL.md)**。

---

## 调用示例

```text
用纯新用户视角（UserSpec）审查一下 http://localhost:5173 的界面和使用体验，先解决第一印象，再测各个界面的联动性。
```

```text
$user-perspective-ux-audit savage
我已经打开了桌面客户端窗口，按完全没见过项目的用户视角挑刺首屏观感、易读性和多面板状态联动。
```

---

## 常见问题 (FAQ)

**为什么不能让同一个 Agent 先读代码启动服务，再“假装”自己是新用户？**
因为剧透是不可逆的。一旦上下文里装进了路由表和组件代码，模型潜意识里就已经知道缩写是什么意思、按钮藏在哪。UserSpec 把“启动服务/改代码”留在主控，把“看界面/点鼠标”关进零背景的独立子代理。

**为什么第一印象没修好就不让测第二阶段功能联动？**
真实用户在第 4 秒看不懂首屏直接关标签页走人了，根本活不到体验你精妙的跨页面状态同步那一刻。先把门脸修明白。

**我做的是开发者工具，界面上露一点枚举值和 JSON 也没关系吧？**
程序员喝咖啡前看到 `ERR_UPSTREAM_NULL_422` 和高低不齐的按钮一样会烦。Specs 戴的是眼镜，不是十六进制解码器。

**原生桌面软件（WPF / Qt / Electron / Tauri）怎么截屏盲测？**
Windows 下自带零依赖脚本 `capture_window.ps1`（基于 Win32 DWM 真实边框与 `SetProcessDPIAware()` 高分屏适配，125%～200% 缩放下依然像素级清晰）；macOS 与 Linux 自带 `capture_window.sh`。

---

## 开源协议

[MIT](LICENSE)。短小直白，没有套话——Specs 很满意。
