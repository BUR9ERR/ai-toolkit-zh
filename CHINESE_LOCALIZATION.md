# 汉化内容与规范详解

本文档说明本汉化包的具体**内容与规范**。应用方式（补丁/覆盖）见仓库根目录 [README.md](README.md) 与 `汉化分享/使用说明.md`。

## 汉化概述

- 对象：官方 [ostris/ai-toolkit](https://github.com/ostris/ai-toolkit) Web UI
- 基于版本：**v0.13.4**（commit `9d6a9a0`）
- 方式：**双语格式** `中文 (English)`，中文为主、完整保留英文原文，方便对照英文文档/源码
- 范围：**51 个文件**，全部位于 `ui/src/` 目录

## 汉化内容

- **全部页面**：Dashboard（仪表盘）/ Datasets（数据集）/ Jobs（任务）/ Settings（设置）等
- **全部组件**：训练配置表单、数据集管理、LoRA 合并、字幕（Caption）、采样图预览、监控面板等
- **帮助文档**：27 条 `?` 弹窗与提示信息
- **交互文案**：aria-label、placeholder、弹窗消息等无障碍与交互文本

## 术语规范

- 严格使用官方术语，专有名词与技术名词**保留英文**，不强行翻译：LoRA、FLUX、GPU、VRAM、Checkpoint、Caption、Trigger Word、EMA、Optimizer 等。

## 不影响功能

- 仅改动前端显示文案，**不涉及**训练、推理、CLI、后端等任何功能代码。

## 界面预览（汉化效果）

![仪表盘 Dashboard（GPU 监控）](https://raw.githubusercontent.com/BUR9ERR/ai-toolkit-zh/main/docs/screenshots/dashboard.png)

![新建训练任务 New Training Job（配置表单）](https://raw.githubusercontent.com/BUR9ERR/ai-toolkit-zh/main/docs/screenshots/jobs_new.png)

![任务队列 Queue](https://raw.githubusercontent.com/BUR9ERR/ai-toolkit-zh/main/docs/screenshots/jobs.png)

## 常见问题

| 问题 | 说明 |
| --- | --- |
| 应用后界面没有变化？ | 汉化改的是前端源码，必须重新构建：`cd ui && npm install && npm run build`，再 `python -m manager launch` |
| 打补丁报错？ | 补丁只对官方 **v0.13.4**（commit `9d6a9a0`）有效；请先确认官方仓库版本一致，或改用覆盖方式 |
| 上游更新后汉化失效？ | 上游改动可能覆盖汉化文件；更新前先备份汉化（`git stash` 或复制文件），更新后重新应用本包 |
