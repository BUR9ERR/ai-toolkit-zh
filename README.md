# AI-Toolkit Web UI 中文双语汉化分享包

本仓库是独立仓库，**只分发汉化产物**（git 补丁、直接覆盖包、配套脚本、说明文档），不包含 [ostris/ai-toolkit](https://github.com/ostris/ai-toolkit) 项目本体代码。clone 本仓库后，按说明把汉化应用到官方 ai-toolkit 即可获得全量双语汉化界面。

## 仓库信息

| 项目 | 说明 |
| --- | --- |
| 本仓库地址 | https://github.com/BUR9ERR/ai-toolkit-zh |
| 官方原版 | https://github.com/ostris/ai-toolkit |
| 完整汉化版（clone 即用，完整代码+汉化） | https://github.com/BUR9ERR/ai-toolkit-l10n |
| 基于版本 | **v0.13.4**（commit `9d6a9a0`） |
| 汉化方式 | 双语格式 `中文 (English)`，保留英文原文与官方术语（LoRA、FLUX、GPU、Checkpoint、Caption 等） |
| 汉化范围 | **51 个文件**，全部位于 `ui/src/` 目录 |

> 想要"clone 下来直接能用的完整汉化版"请走 `BUR9ERR/ai-toolkit-l10n`；本仓库只用于获取汉化产物并应用到自己的官方版。

## 目录结构

```
ai-toolkit-zh/
├── README.md                          # 本说明（总览 + 快速上手）
├── CHINESE_LOCALIZATION.md            # 汉化内容与规范详解
├── 汉化分享/
│   ├── ai-toolkit-l10n-v0.13.4.patch        # git 补丁（方式一，推荐）
│   ├── ai-toolkit-l10n-overlay-v0.13.4.zip  # 直接覆盖版（方式二）
│   └── 使用说明.md                          # 两种方式的详细步骤
├── docs/screenshots/                  # 汉化界面截图（3 张）
├── stop_ui.bat                        # 一键关闭 UI 入口（双击）
├── stop_ui.ps1                        # 关闭 UI 实际脚本（按进程结束 manager launch，释放 8675 端口）
├── stop_ui_结束进程.bat                # 关闭 UI 中文入口（与 stop_ui.bat 等价）
├── update_ai_toolkit.ps1              # 一键更新脚本（检测 GitHub vs 本地 + 安全更新）
└── update_ai_toolkit_一键更新.bat      # 一键更新入口（双击，支持 check/auto 参数）
```

## 快速使用

### 方式一：git 补丁（推荐，适用于 git 克隆的官方仓库）

```bash
git clone https://github.com/ostris/ai-toolkit.git
cd ai-toolkit
git apply 汉化分享/ai-toolkit-l10n-v0.13.4.patch
```

### 方式二：直接覆盖（适合非 git 用户）

解压 `汉化分享/ai-toolkit-l10n-overlay-v0.13.4.zip`，把其中的 `ui/` 文件夹合并覆盖到官方 ai-toolkit 仓库根目录。

> 补丁与覆盖版内容一致，任选一种即可，不要重复使用。详细步骤见 `汉化分享/使用说明.md`。

## 应用后如何生效

汉化改的是前端源码，必须重新构建才能看到效果：

```bash
cd ui
npm install      # 首次需要安装依赖
npm run build    # 重新构建前端
cd ..
python -m manager launch    # 启动 UI，浏览器访问 http://localhost:8675
```

## 配套脚本

| 脚本 | 用途 | 用法 |
| --- | --- | --- |
| `stop_ui.bat` / `stop_ui_结束进程.bat` | 一键关闭 Web UI | 双击运行 |
| `update_ai_toolkit_一键更新.bat` | 一键更新（检测 GitHub 版 vs 本地版 + 安全更新） | 双击进入交互模式；支持参数 `check`（仅检测）、`auto`（免交互更新） |

`update_ai_toolkit.ps1` 的更新逻辑：`git pull --ff-only`（绝不覆盖本地改动）+ 依赖同步 + 数据迁移；本地未提交的定制（汉化等）会自动 `git stash` 备份，更新后 `stash pop` 恢复。

> ⚠️ `update_ai_toolkit.ps1` 中仓库路径硬编码为 `E:\ai-toolkit`，其他用户使用前请修改脚本顶部的 `$repo` 为你本地的官方仓库路径。

## 汉化效果

![仪表盘 Dashboard](docs/screenshots/dashboard.png)

![新建训练任务 New Training Job](docs/screenshots/jobs_new.png)

![任务队列 Queue](docs/screenshots/jobs.png)

## 注意事项

- 汉化基于 v0.13.4 源码上下文；上游更新后这些文件可能被覆盖或产生冲突，更新前请备份汉化（`git stash` 或复制文件）。
- 本仓库与官方仓库相互独立，不受上游同步影响；如遇上游大版本更新，请基于新版本重新生成汉化包。
