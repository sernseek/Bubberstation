# Bubberstation 简体中文汉化分支

> English: see [README.md](./README.md).

[![Upstream](https://img.shields.io/badge/upstream-Bubberstation%2FBubberstation-blue)](https://github.com/Bubberstation/Bubberstation)
[![Locale](https://img.shields.io/badge/locale-zh--Hans-red)](./strings/i18n/zh-Hans)

本仓库是 [**Bubberstation**](https://github.com/Bubberstation/Bubberstation)（[/tg/station](https://github.com/tgstation/tgstation) 经 Skyrat 的下游 fork，BYOND 引擎）的**简体中文汉化分支**，汉化体系移植自 [sernseek/NovaSector](https://github.com/sernseek/NovaSector)：两边同以 /tg/station 为上游，共用同一套工具链、运行时与按内容哈希索引的译文目录，所以 /tg/ 与 Skyrat 共有的文本直接沿用 Nova 汉化版的译文。

**请注意：本仓库包含成人／露骨内容，不适合未满 18 周岁者。**

## 这个分支做了什么

覆盖玩家真正看得到的文本：聊天、检视（examine）、TGUI 界面、站点公告、命令面板（verb）、气泡提示、径向菜单。另外带有 Nova 汉化版的配套模块：中文 TTS 语气与定制音色、说话框频道/语气选择、输入法友好按键、新人地区守卫、离站内容延迟加载等（见 `modular_zh/modules/`）。

语言由一个服务端配置项切换（`config/game_options.txt`）：

```
I18N_SERVER_LOCALE zh-Hans
```

保持默认 `en` 时，整条翻译层是 **no-op**。

### 设计约束

- **机器标识符恒为英文。** act 回传值、`icon_state`、查表键、职位名、ref 一律不翻，只翻显示文本。
- **目录 key 是内容哈希**，上游改词只会让受影响的条目失效，不会悄悄沿用过期译文；与 Nova 共有的文本 key 相同，译文可以双向复用。
- **核心文件改动有标记。** 实现集中在 `modular_zh/`；`code/`、`modular_skyrat/`、`modular_zubbers/` 内的改动是 codemod 产出的 `LANG()` 调用点（文件头带 `ZH EDIT - I18N CODEMOD`）和带 `ZH EDIT` 标记的落地钩子。

## 仓库结构

| 路径 | 内容 |
| --- | --- |
| [`strings/i18n/<locale>/`](./strings/i18n) | 译文目录，扁平 JSON，可直接导入 Crowdin / Weblate / Lokalise |
| [`modular_zh/modules/i18n/`](./modular_zh/modules/i18n/readme.md) | 运行时：`LANG()`、反查、显示边界、落地兜底层 |
| [`tools/i18n/`](./tools/i18n/README.md) | Rust + Node 工具链：抽取、改写、重同步、lint、机器翻译 |
| [`tgui/packages/tgui/i18n/`](./tgui/packages/tgui) | 前端自动本地化与随包目录 |
| [`AGENTS.md`](./AGENTS.md) | 架构说明与本地化陷阱清单 |

常用命令（NixOS 先 `nix develop`）：

```sh
bash tools/i18n/resync.sh          # 合并上游之后：抽取 + 改写 + 审计
bun tools/i18n/mt/i18n-mt.ts       # 机翻补齐新增英文条目
tools/i18n/target/release/nova-i18n verbs --locale zh-Hans   # 翻译后注入新 verb 名
tools/build/build.sh               # 构建
```

## 同步上游

`master` 跟随 Bubberstation 上游；汉化在 `i18n-localization` 分支。合并上游后跑 `tools/i18n/resync.sh`，冲突处理规则见 `tools/i18n/README.md`「同步上游」一节（LANG 行取上游、手写 `ZH EDIT` 逻辑保留）。

## 许可

与上游一致，详见 [README.md](./README.md) 与仓库内 [LICENSE](./LICENSE)、`GPLv3.txt`。`strings/i18n/` 下的译文目录是上游文本的衍生作品，适用相同许可。
