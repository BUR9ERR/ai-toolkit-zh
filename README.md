# AI-Toolkit Web UI 中文双语汉化包

本仓库是 [ostris/ai-toolkit](https://github.com/ostris/ai-toolkit) Web UI 的中文汉化**分享包**，只包含汉化产物（补丁、覆盖文件、配套脚本与说明），不含项目本体代码。clone 后按说明应用到官方 ai-toolkit 即可获得全量双语汉化界面。

- 官方原版：https://github.com/ostris/ai-toolkit
- 基于版本：**v0.13.4**（commit `9d6a9a0`）
- 汉化方式：**双语格式** `中文 (English)`，完整保留英文原文；专有名词保留英文（LoRA、FLUX、GPU、Checkpoint、Caption 等）
- 汉化范围：**51 个文件**，全部位于 `ui/src/` 目录

## 仓库内容

| 路径 | 说明 |
| --- | --- |
| `汉化分享/ai-toolkit-l10n-v0.13.4.patch` | git 补丁（推荐，用于 git 克隆的官方仓库） |
| `汉化分享/ai-toolkit-l10n-overlay-v0.13.4.zip` | 直接覆盖版（适合不想用 git 的人） |
| `汉化分享/使用说明.md` | 使用说明（补丁 / 覆盖两种方式的详细步骤） |
| `CHINESE_LOCALIZATION.md` | 汉化版完整说明（clone 完整仓库的用法） |
| `docs/screenshots/` | 汉化界面截图 |
| `stop_ui.bat` / `stop_ui.ps1` / `stop_ui_结束进程.bat` | 一键关闭 Web UI 工具 |
| `update_ai_toolkit.ps1` / `update_ai_toolkit_一键更新.bat` | 一键更新工具（检测 GitHub 版 vs 本地版 + 安全更新） |

## 快速使用

### 方式一：git 补丁（推荐）

```bash
git clone https://github.com/ostris/ai-toolkit.git
cd ai-toolkit
git apply 汉化分享/ai-toolkit-l10n-v0.13.4.patch
```

### 方式二：直接覆盖（适合非 git 用户）

解压 `汉化分享/ai-toolkit-l10n-overlay-v0.13.4.zip`，把其中的 `ui/` 文件夹合并覆盖到 ai-toolkit 仓库根目录。

> 补丁与覆盖版内容一致，任选一种即可，不要重复使用。

## 应用后如何生效

```bash
cd ui
npm install      # 首次需要安装依赖
npm run build    # 重新构建前端
cd ..
python -m manager launch    # 启动 UI，浏览器访问 http://localhost:8675
```

## 汉化效果

![仪表盘 Dashboard](docs/screenshots/dashboard.png)

![新建训练任务 New Training Job](docs/screenshots/jobs_new.png)

![任务队列 Queue](docs/screenshots/jobs.png)

## 注意事项

- 汉化基于 v0.13.4 源码上下文；上游更新后这些文件可能被覆盖或产生冲突，更新前请备份汉化（`git stash` 或复制文件）。
- `update_ai_toolkit.ps1` 中仓库路径硬编码为 `E:\ai-toolkit`，其他用户使用前请修改脚本顶部的 `$repo` 为你本地的官方仓库路径。
- 本仓库与官方仓库相互独立，不会因上游同步产生冲突。
