---
name: user-perspective-ux-audit
description: >-
  Zero-context usability lab skill for AI coding agents. Audits Web, Mobile H5/Responsive, and
  Native/Electron desktop interfaces through an isolated blind first-time user subagent. Enforces
  a strict Stage 1 gate (5-second comprehension, visual craft, zero dev-jargon readability) before
  Stage 2 testing (interaction fluency and F5-free cross-view state linkage). Depth modes: glance,
  gate (default), stress. Use whenever the user asks to review, critique, test, or polish UI/UX,
  first impression, usability, visual hierarchy, or multi-page state linkage from an end-user perspective.
argument-hint: "[glance|gate|stress] [url-or-window]"
license: MIT
---

# UserSpec — Zero-Context Usability Lab

> **First impression first. Cross-view linkage second. Zero source-code spoilers.**
> **面向 AI 编码代理的零先验可用性实验室 —— 先过 5 秒首屏门禁，再测跨界面状态联动。**

## Operating Persona & Output Standard (可用性实验室规范)

During an audit, the blind test subject acts as an everyday first-time user who has never seen the project, holds no domain assumptions, and expects the interface to explain itself without documentation or manual page reloads (`F5`).

- **Language Matching**: Match the user's conversation language across all reports, confirmation prompts, and lab receipts (English conversation → English output; Chinese conversation → Chinese output).
- **Usability Lab Receipt (必填验收回执栏)**: End **every** audit report or verification update with this concise structured receipt:

  ```markdown
  ---
  **UserSpec Lab Receipt** | Mode: `<glance|gate|stress>` | Gate: `<STAGE 1 LOCKED | STAGE 1 PASSED | STAGE 2 VERIFIED>`
  **Isolation**: Blind subagent (0 repo files read) · **Inspected**: `<exact routes/windows & viewports>` · **Pending / Risks**: `<unchecked surfaces or active blockers>`
  ```
  *(Chinese equivalent: `**UserSpec 可用性实验室回执** | 档位：\`<glance|gate|stress>\` | 门禁：\`<阶段一锁定 | 阶段一通过 | 阶段二验收完成>\`` + `**隔离证明**：盲测子代理零源码读取 · **已测范围**：\`<页面/窗口与视口>\` · **未测与风险**：\`<待解锁项或残余风险>\``.)*

---

## Audit Depth Modes (`glance` | `gate` | `stress`)

| Mode | Scope & Behavior |
| :--- | :--- |
| **`glance`** | **5-Second First-Impression Screen.** Executes Stage 1 only on the entry view (comprehension, visual hierarchy, readability, dev-jargon scan). Returns a concise diagnostic report without modifying code unless requested. |
| **`gate`** | **Default. Two-Stage Gatekept Audit.** Enforces blind subagent isolation → Stage 1 diagnosis → user confirms fix list → coordinator patches code → **fresh** blind subagent re-verifies Stage 1 → unlocks Stage 2 fluency and 5+ F5-free cross-view linkage chains. |
| **`stress`** | **Exhaustive Boundary & Linkage Stress Test.** Includes everything in `gate`, plus aggressive edge testing: multi-viewport & live resize stress, rapid double-submit checks, full `0 → 1 → N → 0` lifecycle transitions, 50+ char / special-character overflow across linked views, and explicit recommendations to simplify or remove confusing controls. |

---

## 一、 零先验盲测隔离协议 (Zero-Context Isolation Protocol)

当同一个模型先阅读源码再去审查界面时，上下文污染会导致严重的“开发者盲区”（预先知道缩写含义、隐藏入口和缓存刷新机制）。执行本 Skill 必须遵守三条工程隔离红线：

1. **双角色物理隔离（Coordinator vs. Blind Test Subject）**
   - **主控协调者（Coordinator）**：负责与用户对齐、启动本地服务或桌面应用、内部留存真实产品定位（仅用于对照评估盲测猜测偏差）、向用户汇报清单并按确认项修改代码。
   - **盲测受试子代理（Blind Subagent）**：严禁读取任何项目源码、`README.md`、`package.json`、路由配置、接口定义或 Git 历史，只能通过真实渲染截图与界面键鼠操作感知软件。
2. **零剧透入口传递（Bare Entry Only）**
   - 下发给盲测子代理的指令**只能包含裸入口**（如 `http://localhost:5173` 或桌面窗口 PID/标题）。
   - ❌ **违规**：“打开 `http://localhost:3000` 这个任务管理看板，检查新建任务和仪表盘统计……”
   - ✅ **合规**：“打开 `http://localhost:3000`，以完全没见过该软件的新用户身份记录前 5 秒直觉与首屏观感……”
3. **复检必须更换全新受试者（Fresh-Subject Retest）**
   - 阶段一代码修改完成后，必须通过 `invoke_subagent` 启动**全新的盲测子代理**重测首屏第一印象，严禁向已看过旧界面的子代理发送 `send_message` 充当“第一印象复检”。

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

## 三、 两阶段门禁式实验流程 (Two-Stage Gatekept Protocol)

### 阶段一：第一印象、观感与易读性盲测（禁止深点业务功能）

1. 主控读取 [phase1-first-impression-checklist.md](./references/phase1-first-impression-checklist.md) 与 [audit-report-template.md](./references/audit-report-template.md)。
2. 派遣盲测子代理执行首屏观察、滚动浏览、悬停提示与双视口截图（**禁止深入点击业务增删改功能**）：
   - **第一印象（5 秒认知测试）**：盲测回答“软件用途、目标用户、首要行动点（Primary CTA）、首屏困惑点”。
   - **观感（Visual Craft）**：视觉主次层级、对齐与留白秩序、色彩语义克制度、半成品痕迹（原生丑控件/裂图/假文）、多端视口排版。
   - **易读性（Readability & Zero Dev-Speak）**：对比度与字号行高、空状态引导，严查**开发腔外露**（`STATUS_PENDING`、`undefined`、原始 ISO 时间戳、UUID、技术黑话、中英混杂）。
3. **门禁汇报与用户确认**：
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

### 阶段二：交互流畅度与禁用 `F5` 的多界面联动测试

仅当阶段一门禁通过（或用户明确放行）后执行：

1. 主控读取 [phase2-fluency-and-linkage-matrix.md](./references/phase2-fluency-and-linkage-matrix.md)。
2. 派遣测试子代理以不看文档的真实用户方式探索核心流程，实测两大维度：
   - **流畅度（Fluency）**：点击即时反馈、异步 Loading 与骨架屏过渡、零布局跳动（CLS）、**快速双击防重提交**、表单报错保留已填内容、防误触遮罩丢稿、无“进得去退不出来”的死胡同页面。
   - **多界面联动性（Cross-View Linkage — 全程严禁手动按 `F5` 刷新）**：至少完整实测 **5 条**跨视图状态联动链路：
     1. `增删改 / 状态变更` → 切到**首页概览统计卡片 / 图表 / 侧边栏角标 / 全局搜索**核验实时同步；
     2. `详情页或设置页重命名 / 改分类` → 返回**主列表 / 看板 / 其他表单下拉框**核验无旧缓存残留；
     3. `列表搜索 + 筛选 + 翻页` → 进入详情再点**界面返回与浏览器后退**，核验筛选条件、页码与菜单高亮保持；
     4. `切换深浅色主题 / 语言 / 个人资料 / 全局开关` → 核验**弹窗、浮层、图表与子页面**全量同步无样式撕裂；
     5. `0 条空状态 → 新建第 1 条 → 超长/特殊字符条目 → 删空回 0 条` 全生命周期边界切换与跨界面截断表现。
3. **阶段二汇报与闭环**：输出复现路径、跨页面对比截图与 `UserSpec Lab Receipt` → 用户确认需修复项 → 修复代码 → 按原路径无刷新回归验证，达成 **`STAGE 2 VERIFIED`**。

---

## 四、 交付前核验清单 (Pre-Delivery Check)

- [ ] 盲测子代理是否全程零源码接触？报告引用的地址与截图是否与 `BROWSER_HOST_FACTS` 或真实窗口截图一致？
- [ ] 是否严格遵守阶段一门禁，未在首屏过关前抢跑阶段二？是否在用户确认前擅自改了代码？
- [ ] 每条问题是否落实到具体组件、文案或跨页面链路，并在报告末尾附上了规范的 `UserSpec Lab Receipt`？
