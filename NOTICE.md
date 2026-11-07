# NOTICE — 授权与版权构成说明

本文件说明本仓库中**各部分内容的版权归属与授权条件**。请先读它，再决定如何使用本仓库的任何内容。

This file explains the **copyright ownership and licensing of each part** of this repository. Please read it before reusing anything here.

---

## 1. 一句话说明 / In one sentence

> 本仓库是**非官方汉化项目**，它建立在两个我们并不拥有、也**未获得再分发授权**的来源之上：原游戏作者的代码与资源，以及《蔚蓝档案》的官方素材。**我们只是汉化部分的作者。**

> This is an **unofficial localization project** built on two upstreams we neither own nor have a redistribution license for: the original game's code and assets, and the official *Blue Archive* material. **We only authored the localization layer.**

---

## 2. 逐部分说明 / Per-part breakdown

| # | 内容 / Part | 位置 / Where | 权利人 / Rights holder | 授权状态 / License |
|---|---|---|---|---|
| 1 | **汉化新增内容**<br>译文、本地化系统、排版适配代码、中文图像字、本文档 | `assets/locale/zh_cn.json`<br>`scripts/core/loc.gd`<br>`assets/ba/hud/words_zh/`<br>`docs/`、`README.md`、`NOTICE.md`、`CHANGELOG.md`<br>`tools/*.py`、`tools/*.cjs`、`tools/check_glyphs.gd` | **Motu Game Tech（冇圡游戏科技）** | **CC BY-NC-SA 4.0**<br>署名、非商业、相同方式共享。详见 `LICENSE`。 |
| 2 | **原游戏代码**<br>GDScript、场景、着色器 | `scripts/`、`scenes/`、`shaders/`、`project.godot` 等 | **mattsumi** | **未声明开源许可**（上游仓库无 LICENSE 文件）。<br>我们**没有**从上游获得再分发授权。 |
| 3 | **原游戏资源**<br>3D 模型、贴图、音效、音乐、字体（原版）、视频 | `assets/`（除第 1、4 项） | **mattsumi** / **NEXON Games** / **Yostar** | 同第 2 项；其中《蔚蓝档案》相关素材的知识产权归 NEXON Games 与 Yostar。 |
| 4 | **第三方字体** | `assets/fonts/NotoSansSC-*.ttf` 等 | The Noto Project Authors 等 | **SIL Open Font License 1.1**，可随软件分发；声明见 `assets/fonts/OFL-*.txt` 与 `docs/中文字体授权.txt`。 |
| 5 | **第三方图标与工具** | `assets/glyphs/`、`tools/third_party/` | Kenney、SkelToJson 作者等 | CC0 / 各自许可，见 `assets/glyphs/LICENSE.txt`、`tools/third_party/SkelToJson/LICENSE`。 |
| 6 | **Godot 引擎** | 不随仓库分发（构建产物内嵌） | Godot Engine contributors | MIT License |

---

## 3. 关于上游授权的重要说明 / Important note on upstream licensing

**上游仓库 [mattsumi/blue-archive-fighting-game](https://github.com/mattsumi/blue-archive-fighting-game) 没有 LICENSE 文件，GitHub 也标识其许可为 "无"。**

按通行的著作权规则，**没有许可证意味着「保留所有权利」**，而不意味着「可以自由使用」。因此：

- 本仓库中的原游戏代码与资源，**不是**由我们授权给你使用的；
- 我们在本仓库中对汉化部分采用的 CC BY-NC-SA 4.0，**不会、也不能**覆盖第 2、3 项内容；
- 本仓库存在的主要理由是**方便玩家获取汉化版并进行同人交流**，并非主张对原游戏任何部分的授权。

**Upstream has no LICENSE file.** No license means **all rights reserved**, not "free to use". Our CC BY-NC-SA 4.0 covers **only** our localization layer (row 1 above), never the upstream code or the Blue Archive assets.

---

## 4. 如果你要复用 / If you want to reuse

| 你想做什么 | 需要谁同意 |
|---|---|
| 搬运本汉化到别处、二次修改汉化、用于非商业同人 | 遵守 **CC BY-NC-SA 4.0**（署名 Motu Game Tech、非商业、相同方式共享） |
| 使用原游戏代码/资源做**任何**用途 | 联系原作者 **mattsumi**（见上游仓库 Issues） |
| 使用《蔚蓝档案》相关素材 | 联系权利人 **NEXON Games / Yostar** |
| 使用字体 | 遵守 **OFL 1.1**（可自由使用与再分发，不得单独售卖字体本身，不得使用保留字体名） |

---

## 5. 下架请求 / Takedown

如果你是本项目所涉内容的权利人，认为本仓库的某部分侵犯了你的权益，请通过本仓库的 **Issues** 联系我们并说明具体文件与理由。我们会在核实后**立即删除或调整**相关内容，无需走法律程序。

If you are a rights holder and believe part of this repository infringes your rights, please open an **Issue** describing the exact files and the reason. We will remove or adjust the material promptly.

---

<sub>Last updated: 2026-11-08 · Motu Game Tech（冇圡游戏科技）</sub>
