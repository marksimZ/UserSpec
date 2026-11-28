---
name: user-perspective-ux-audit
description: >-
  Three-stage zero-context usability lab skill for AI coding agents. Audits Web, Mobile H5/Responsive,
  and Native/Electron desktop interfaces through an isolated blind first-time user subagent:
  Stage 1 (5-second first impression, visual craft, zero dev-jargon readability),
  Stage 2 (secret ground-truth ledger vs. two-pass unguided full-feature discovery & end-to-end workflow completion),
  and Stage 3 (interaction fluency & F5-free cross-view state linkage). Depth modes: glance, gate (default), stress.
  Use whenever the user asks to review, critique, test, or polish UI/UX, first impression, feature discoverability,
  end-to-end user workflows, or multi-page state linkage from a real user's perspective.
argument-hint: "[glance|gate|stress] [url-or-window]"
license: MIT
---

# UserSpec — Zero-Context Usability Lab

> **First impression first. Unguided full-workflow completion second. Cross-view linkage third.**
> **面向 AI 编码代理的零先验可用性实验室 —— 先过 5 秒首屏门禁，再验无提示全功能与工作流跑通，最后测无 F5 跨界面联动。**

## Operating Persona & Output Standard (可用性实验室规范)

During an audit, the blind test subject acts as an everyday first-time user who has never seen the project, holds no domain assumptions, and expects the interface to explain itself and guide every workflow to completion without documentation or manual page reloads (`F5`).

- **Language Matching**: Match the user's conversation language across all reports, confirmation prompts, and lab receipts (English conversation → English output; Chinese conversation → Chinese output).
- **Usability Lab Receipt (必填验收回执栏)**: End **every** audit report or verification update with this concise structured receipt:

  ```markdown
  ---
  **UserSpec Lab Receipt** | Mode: `<glance|gate|stress>` | Gate: `<STAGE 1 LOCKED | STAGE 1 PASSED | STAGE 2 LOCKED | STAGE 2 PASSED | STAGE 3 VERIFIED>`
  **Isolation**: Blind subagent (0 repo files read) · **Inspected**: `<exact routes/windows & viewports>` · **Coverage**: `Discovery X/N · Workflows Y/M (or Pending Stage 2)` · **Pending / Risks**: `<unchecked surfaces or active blockers>`
  ```
  *(Chinese equivalent: `**UserSpec 可用性实验室回执** | 档位：\`<glance|gate|stress>\` | 门禁：\`<阶段一锁定 | 阶段一通过 | 阶段二锁定 | 阶段二通过 | 阶段三验收完成>\`` + `**隔离证明**：盲测子代理零源码读取 · **已测范围**：\`<页面/窗口与视口>\` · **覆盖度**：\`功能发现 X/N · 工作流跑通 Y/M（或待解锁阶段二）\` · **未测与风险**：\`<待解锁项或残余风险>\``.)*

---

## Audit Depth Modes (`glance` | `gate` | `stress`)

| Mode | Scope & Behavior |
| :--- | :--- |
| **`glance`** | **5-Second First-Impression Screen.** Executes Stage 1 only on the entry view (comprehension, visual hierarchy, readability, dev-jargon scan). Returns a concise diagnostic report without modifying code unless requested. |
| **`gate`** | **Default. Three-Stage Gatekept Audit.** Enforces blind subagent isolation → **Stage 1** first-impression fix & fresh-subject retest gate → **Stage 2** secret ground-truth ledger vs. two-pass unguided full-feature & end-to-end workflow completion gate → **Stage 3** interaction fluency and 5+ F5-free cross-view linkage chains. |
| **`stress`** | **Exhaustive Boundary & Linkage Stress Test.** Includes everything in `gate`, plus aggressive edge testing: multi-viewport & live resize stress, rapid double-submit checks, full `0 → 1 → N → 0` lifecycle transitions, 50+ char / special-character overflow across linked views, and explicit recommendations to simplify or remove confusing controls. |

---

## 一、 零先验盲测隔离协议 (Zero-Context Isolation Protocol)

当同一个模型先阅读源码再去审查界面时，上下文污染会导致严重的“开发者盲区”（预先知道缩写含义、隐藏入口和缓存刷新机制）。执行本 Skill 必须遵守三条工程隔离红线：

1. **双角色物理隔离（Coordinator vs. Blind Test Subject）**
   - **主控协调者（Coordinator）**：负责与用户对齐、启动本地服务或桌面应用、内部留存真实产品定位与《全量功能/工作流底账》（仅用于后台对账）、向用户汇报清单并按确认项修改代码。
   - **盲测受试子代理（Blind Subagent）**：严禁读取任何项目源码、`README.md`、`package.json`、路由配置、接口定义或 Git 历史，只能通过真实渲染截图与界面键鼠操作感知软件。
2. **零剧透入口传递（Bare Entry Only）**
   - 下发给盲测子代理的指令**只能包含裸入口**（如 `http://localhost:5173` 或桌面窗口 PID/标题）。
   - ❌ **违规**：“打开 `http://localhost:3000` 这个任务管理看板，测试新建任务、右键归档和仪表盘统计……”
   - ✅ **合规**：“打开 `http://localhost:3000`，以完全没见过该软件的新用户身份记录前 5 秒直觉与首屏观感……”
3. **跨门禁复检必须更换全新受试者（Fresh-Subject Retest）**
   - 阶段一或阶段二修改代码完成后，必须通过 `invoke_subagent` 启动**全新的盲测子代理**重新验收（验证真正的新用户能否不靠记忆看懂或找到入口），严禁对旧子代理 `send_message` 充当“初见复检”。

---

## 二、 多平台执行与登录墙处理 (Surfaces & Auth Walls)

### 1. 全平台适配
开始前读取 [platform-adapters.md](./references/platform-adapters.md) 确定执行载体：
- **Web 桌面端**：内置 `browser` 子代理（默认视口 `1440×900`）。
- **移动端 H5 / 响应式网页**：`browser` 子代理双视口对比（`1440×900` + `390×844`），严查横向滚动条溢出、触控热区（`<44px`）与抽屉菜单跳转未自动收起问题。
- **原生桌面客户端 / Electron / Tauri**：纯净沙盒 `self` 子代理 + 零依赖窗口截图脚本（Windows 用 [capture_window.ps1](./scripts/capture_window.ps1)，macOS/Linux 用 [capture_window.sh](./scripts/capture_window.sh)）。

### 2. 登录墙与冷启动门槛策略
若入口首先呈现**落地页或登录/注册墙**：
1. **外层第一印象评估**：在要求用户输入账号密码前，界面是否清楚说明了产品用途与核心价值？若只有孤立的登录表单而无价值说明，记为阶段一高优缺陷。
2. **真实新用户自助进入优先**：优先尝试“游客体验 / 示例模式 / 跳过”；若无则使用明显测试数据走一遍新用户注册流程，同步记录表单摩擦与引导质量。
   - **安全停机条件**：遇到图形验证码（CAPTCHA）、真实短信/邮箱验证码、强制第三方 OAuth、邀请码或付费墙时，**立即停止并返回 `AUTH_REQUIRED`**（严禁绕过任何安全验证），由主控向用户索要测试账号。
3. **内层主工作台二次首屏体检**：首次进入登录后主工作台时，同样执行完整的阶段一 5 秒直觉与易读性体检。

---

## 三、 三阶段门禁式实验流程 (Three-Stage Gatekept Protocol)

### 阶段一：第一印象、观感与易读性盲测（禁止深点业务功能）

1. 主控读取 [phase1-first-impression-checklist.md](./references/phase1-first-impression-checklist.md) 与 [audit-report-template.md](./references/audit-report-template.md)。
2. 派遣盲测子代理执行首屏观察、滚动浏览、悬停提示与双视口截图（**禁止深入点击业务增删改功能**）：
   - **第一印象（5 秒认知测试）**：盲测回答“软件用途、目标用户、首要行动点（Primary CTA）、首屏困惑点”。
   - **观感（Visual Craft）**：视觉主次层级、对齐与留白秩序、色彩语义克制度、半成品痕迹（原生丑控件/裂图/假文）、多端视口排版。
   - **易读性（Readability & Zero Dev-Speak）**：对比度与字号行高、空状态引导，严查**开发腔外露**（`STATUS_PENDING`、`undefined`、原始 ISO 时间戳、UUID、技术黑话、中英混杂）。
3. **门禁 1 汇报与用户确认**：
   - 将盲测员原话猜测与真实产品定位对照呈现，按 `P0 Blocker` / `P1 Major` / `P2 Minor` 列出问题清单、证据截图与 `UserSpec Lab Receipt`。
   - 在 `gate` / `stress` 模式下**暂停并请用户拍板修改项**（未获确认绝不擅自改动业务代码）。
4. **修复与全新受试者复检**：按确认清单修复代码 → 启动**全新**盲测子代理复测阶段一 → 通过后标记 **`STAGE 1 PASSED`**，解锁阶段二。

#### Blind Test Subject Prompt Template — Stage 1 (严禁附带项目背景)

```text
You are a blind usability test subject encountering this software for the first time with zero prior context.
[Entry Target]: <bare URL or Window PID/Title ONLY>
[Strict Isolation]: NEVER read, search, or list any source code, README, or config files in the workspace.

Run Stage 1 (First Impression, Visual Craft & Readability) ONLY — do NOT click deep into CRUD features yet:
1. Capture the initial viewport immediately. Before scrolling or clicking, answer from your first 5 seconds:
   - What does this software appear to do?
   - Who is the apparent target audience?
   - What is the primary call-to-action, and how long did it take to spot?
   - What immediately creates confusion or friction?
2. If greeted by a login/signup wall: evaluate whether product value is explained before requesting credentials; then attempt Guest/Demo mode or self-signup as a new user. STOP immediately and return AUTH_REQUIRED if gated by CAPTCHA, real SMS/email OTP, mandatory OAuth, invite code, or payment. Upon entering the main workspace, repeat Step 1 on the workspace home view.
3. Scroll and inspect only the entry view (for Web, capture both Desktop 1440×900 and Mobile 390×844 viewports):
   - Visual Craft: hierarchy, alignment, spacing, color restraint, component consistency, unstyled native widgets, overflow/clipping.
   - Readability: contrast, typography, empty-state guidance, and ANY developer leaks (raw enums like STATUS_PENDING, null/undefined, raw ISO timestamps, UUIDs, cryptic acronyms).
4. Return all screenshot paths, your verbatim 5-second comprehension notes, and specific UI defects with exact screen locations.
```

---

### 阶段二：无提示全功能自主探索与工作流完通审计 (Unguided Feature & Workflow Discovery)

仅当 **`STAGE 1 PASSED`**（或用户明确放行）后执行；详细方法见 [phase2-feature-and-workflow-discovery.md](./references/phase2-feature-and-workflow-discovery.md)：

1. **主控暗建《全量功能与工作流底账》（绝不剧透给盲测员）**：
   - 主控静默扫描项目路由、菜单组件、右键/划词事件、拖拽区、快捷键与后端端点，内部列全：
     - **全量功能清单 (`F-01 .. F-N`)**（含隐藏/上下文交互）；
     - **端到端核心工作流 (`W-01 .. W-M`)** 及每条流的 **DoD 最终验收标准**（仅点开弹窗看一眼计为 0% 完成度）。
2. **第 1 轮（Pass 1）：100% 纯无提示自主通关**：
   - 派遣盲测子代理执行**零提示深度通关**（禁止透露任何底账内容）：盲测员根据界面信息自己制定用户目标、构造真实输入数据、穷举可见交互线索（菜单、Tab、Hover、右键、文本划选、折叠项、空状态引导），把能发现的工作流从头做到最终产出，并交回《主观功能地图》。
3. **双向差集对账**：
   - 主控比对《主观功能地图》与《全量底账》，算出**功能发现率 (`X/N`)**与**工作流完通率 (`Y/M`)**，标记 🟢 自主顺畅 / 🟡 绕弯跑通 / 🟠 中途卡死 / 🔴 幽灵功能（0% 发现）。
4. **第 2 轮（Pass 2）：对 🔴 幽灵功能执行“仅给用户目标、不给操作路径”补测**：
   - 若 Pass 1 存在漏掉的 🔴 幽灵功能，主控通过 `send_message` 下发**只说用户想干什么、绝不说按钮在哪**的纯目标补测指令：
     - **Pass 2 跑通** → 定级 `P1 可发现性/入口线索缺陷`（入口藏太深，需要增加显性提示）；
     - **Pass 2 仍失败** → 定级 `P0 流程断流/交互阻断缺陷`（带着明确目的也找不到或走不通）。
5. **门禁 2 汇报与复检**：按模板二输出覆盖率报告与对账表 → 暂停请用户确认修改项 → 主控改代码 → 启动**全新**盲测子代理复验无提示通关 → 达标后标记 **`STAGE 2 PASSED`**，解锁阶段三。

#### Blind Test Subject Prompt Template — Stage 2 Pass 1 (Zero-Hint Deep Walkthrough)

```text
[Stage 2 — Pass 1: Zero-Hint Full-Feature & End-to-End Workflow Walkthrough]
Continue from the rendered UI ONLY. Do NOT read any source code, README, or config files, and do NOT guess hidden URLs.

Your goal is to find out EVERYTHING this software can actually do and complete its real end-to-end workflows from scratch — not just click around superficially:
1. Deduce concrete real-world tasks a user is supposed to accomplish here. Construct realistic test inputs and execute every workflow all the way to its final saved output and downstream use (merely opening and closing a dialog does NOT count).
2. Exhaustively probe visible UI affordances: navigation tabs, empty-state buttons, secondary/collapsed panels, hover tooltips, right-click context menus on list items or canvases, text-selection popovers, drag-and-drop zones, and settings sub-tabs.
3. Submit a "Blind Mental Map":
   - Completed end-to-end workflows (goal -> exact steps taken -> final outcome & screenshot paths)
   - Stalled/broken workflows (where you got stuck, what cue was missing, or what error blocked completion)
   - Complete inventory of every feature you believe exists in this product.
```

#### Blind Test Subject Prompt Template — Stage 2 Pass 2 (Goal-Only Nudge for Missed Features)

```text
[Stage 2 — Pass 2: Goal-Only Usability Check]
In your first pass you did not notice or complete the following user goal(s):
- Goal A: "<Plain-language user intent ONLY, e.g., 'Save part of an AI answer as reusable knowledge' — ZERO UI hints on buttons, menus, or routes>"

Without any guidance on where to click, search the interface with this explicit goal in mind and try to complete it end-to-end. Report whether you found it, how long/how many wrong turns it took, or exactly where you got stuck, with screenshots.
```

---

### 阶段三：交互流畅度与禁用 `F5` 的多界面联动性深度测试

仅当 **`STAGE 1 PASSED`** 且 **`STAGE 2 PASSED`**（或用户明确放行）后执行；详细矩阵见 [phase3-fluency-and-linkage-matrix.md](./references/phase3-fluency-and-linkage-matrix.md)：

1. 主控读取 [phase3-fluency-and-linkage-matrix.md](./references/phase3-fluency-and-linkage-matrix.md)。
2. 派遣测试子代理结合阶段二已探明的全量视图，实测两大维度：
   - **流畅度（Fluency）**：点击即时反馈、异步 Loading 与骨架屏过渡、零布局跳动（CLS）、**快速双击防重提交**、表单报错保留已填内容、防误触遮罩丢稿、无“进得去退不出来”的死胡同页面。
   - **多界面联动性（Cross-View Linkage — 全程严禁手动按 `F5` 刷新）**：至少完整实测 **5 条**跨视图状态联动链路：
     1. `增删改 / 状态变更` → 切到**首页概览统计卡片 / 图表 / 侧边栏角标 / 全局搜索**核验实时同步；
     2. `详情页或设置页重命名 / 改分类` → 返回**主列表 / 看板 / 其他表单下拉框**核验无旧缓存残留；
     3. `列表搜索 + 筛选 + 翻页` → 进入详情再点**界面返回与浏览器后退**，核验筛选条件、页码与菜单高亮保持；
     4. `切换深浅色主题 / 语言 / 个人资料 / 全局开关` → 核验**弹窗、浮层、图表与子页面**全量同步无样式撕裂；
     5. `0 条空状态 → 新建第 1 条 → 超长/特殊字符条目 → 删空回 0 条` 全生命周期边界切换与跨界面截断表现。
3. **阶段三汇报与闭环**：按模板三输出复现路径、跨页面对比截图与 `UserSpec Lab Receipt` → 用户确认需修复项 → 修复代码 → 按原路径无刷新回归验证，达成 **`STAGE 3 VERIFIED`**。

---

## 四、 交付前核验清单 (Pre-Delivery Check)

- [ ] 盲测子代理是否全程零源码接触？给盲测员的 Prompt 是否未泄露任何底账功能名或操作路径？引用的地址与截图是否与 `BROWSER_HOST_FACTS` 或真实窗口截图一致？
- [ ] 是否严格遵守三阶段门禁顺序（阶段一首屏 → 阶段二无提示全功能通关 → 阶段三跨页联动）？是否在用户确认前擅自改了代码？
- [ ] 每条问题是否落实到具体组件、文案、功能缺失或跨页面链路，并在报告末尾附上了规范的 `UserSpec Lab Receipt`？
