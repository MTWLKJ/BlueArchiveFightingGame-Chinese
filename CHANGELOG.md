# Changelog — 更新日志

本项目的所有重要变更都会记录在此文件。版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。
All notable changes to this project are documented here.

---

## [v1.0.0] — 2026-11-08

**首个正式简体中文汉化版本 / First public Simplified Chinese release.**

### 新增 / Added

- **简体中文汉化**：791 条英文 → 中文对照表（`assets/locale/zh_cn.json`），覆盖全部玩家可见文本。
- **本地化系统**：新增 `scripts/core/loc.gd`（自动加载单例 `Loc`），英文原文保留在代码中，中文单独成表；`Loc.t()` 查不到时原样返回，不会出现空白。
- **中文字体**：接入 **Noto Sans SC** 6 个字重（SIL OFL 1.1），以 `Font.fallbacks` 回退方式挂在原有拉丁字体之后，拉丁字母与数字保持原版字形。字体按实际用字裁剪（60 MB → 2.2 MB）。
- **中文战斗图像字**：28 张（第 N 回合 / 最终回合 / 战斗 / 开始 / 胜利 / 败北 / K.O. / 时间到 / 平局 / 训练 / 警告 / 格挡 / 抵抗 / 未命中 / 免疫 / 连击 / 最佳记录 / 必杀 / EX 就绪 / 完美防御 / 破防），按原图像素尺寸重新烘焙，随语言自动切换。
- **中文排版**：文案量测改为按译文宽度计算；新增按字断行与行首禁则（`，。、！？」』` 不出现在行首），角色简介与制作人员长段落正常折行。
- **语言切换**：设置页新增「语言」一行，简体中文 ⇄ English 即时生效，并写入 `settings.cfg` 的 `[ui] language`。
- **制作人员署名**：在制作人员名单末尾新增「简体中文汉化 / SIMPLIFIED CHINESE LOCALIZATION」栏目，署名 **Motu Game Tech（冇圡游戏科技）** 与 7 项汉化贡献。
- **验证工具**：`tools/check_glyphs.gd`（字体缺字校验）、`tools/loc_coverage.py`（漏译统计）、`tools/make_zh_words.py`（图像字重烘焙）、`tools/subset_fonts.cjs`（字体裁剪）。
- **文档**：`docs/汉化说明.md`、`docs/汉化完成度报告.md`、`docs/未汉化内容及原因.md`、`docs/中文字体授权.txt`。

### 汉化范围 / Coverage

| 项目 | 结果 |
|---|---|
| 对照表条目 | 791 |
| 角色名（官方简中译名） | 83 |
| 助战角色名与学校名 | 81 |
| 角色简介段落 | 80 |
| 中文缺字 | 0（6 个字重 × 1,076 用字逐一校验） |
| UI 文字溢出 | 0 |
| 界面英文残留 | 0（刻意保留项见 `docs/未汉化内容及原因.md`） |

### 修复 / Fixed

- **Windows 保留设备名导致项目无法在 Windows 上使用**：上游 `assets/glyphs/*/aux.png` 使用了 Windows 保留设备名 `AUX`，导致 `git clone` 报 `invalid path`、Godot 读不到该文件、「设置 → 按键图标」页面报错退出。汉化版将文件更名为 `aux_.png`，并在 `scripts/ui/controller_glyphs.gd` 中做兼容读取（先试原名，再试 `aux_.png`，其他平台行为不变）。
- **按键图标预览的空贴图崩溃**：`options_screen.gd` 在贴图缺失时直接调用 `draw_texture_rect(null)`，已加空值保护。

### 未改动 / Unchanged

以下内容**一行未改**，与上游保持一致：战斗数值、攻击判定、角色动作与动画、AI 行为、物理系统、游戏模式、存档格式、Godot 引擎版本（4.7.2）。详见 `docs/汉化说明.md`。

### 已知问题 / Known issues

- 标题 LOGO「Blue Archive Fighting Game」为位图美术，保留原样。
- 3D 地图贴图中的英文路牌（如 `DO NOT ENTER`）烘焙在美术资源内，未修改。
- 格斗帧表记号 `5L / 5H / 2L / 2H / jL / jH` 与武器缩写 `MG / SG` 按行业惯例保留英文。
- 角色语音仍为原版日语音源，中文字幕已汉化。

完整说明见 [`docs/未汉化内容及原因.md`](docs/未汉化内容及原因.md)。

---

## [上游基线] — 2026-11-02

基于 `mattsumi/blue-archive-fighting-game` 的 `main` 分支快照（提交 `988798bd4facd5307ba7efc63ff6e0055924a25b`）。
The localization is based on upstream commit `988798b` (2026-11-02).

---

<sub>版本格式：`主版本.次版本.修订号`；跨上游版本升级时同步更新上游基线说明。</sub>
