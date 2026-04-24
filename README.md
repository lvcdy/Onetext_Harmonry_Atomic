# OneText Harmony Atomic Service

OneText 是一个 HarmonyOS Atomic Service 项目，提供一言句子展示、桌面小组件、刷新内容和保存图片等能力。

## 项目简介

本项目当前入口模块为 `entry`，主页面加载 `pages/Index`。应用以原子化服务形态运行，适配手机、平板和 2in1 设备。

## 主要功能

- 随机展示一句文本内容
- 提供桌面小组件，便于快速查看句子
- 支持刷新内容
- 支持将句子保存为图片
- 提供设置页和关于页

## 目录结构

- `AppScope/`：应用级配置
- `entry/`：主模块代码、资源和构建配置
- `src/main/ets/`：ArkTS 源码
- `src/main/resources/`：多语言资源、图片和页面配置
- `build-profile.json5`：构建与签名配置

## 环境要求

- HarmonyOS 开发环境
- DevEco Studio
- 已安装对应版本的 HarmonyOS SDK

## 运行方式

1. 使用 DevEco Studio 打开工程根目录。
2. 检查 `build-profile.json5` 中的构建配置是否匹配本机环境。
3. 配置 HarmonyOS 签名后，执行构建或直接在模拟器/真机上运行。

## 开源许可证

本项目采用 `LGPL-3.0` 开源许可证，仓库根目录已新增 [LICENSE](LICENSE) 文件。

如果你要二次分发或修改后发布，请先确认你的使用方式符合 LGPL-3.0 的要求。

另外，`build-profile.json5` 中仍包含 HarmonyOS 本地签名配置，这部分与开源许可证是两回事，不建议提交个人证书、私钥和 profile 文件。

## 权限说明

工程申请了以下权限：

- `ohos.permission.INTERNET`
- `ohos.permission.DETECT_GESTURE`
- `ohos.permission.WRITE_IMAGEVIDEO`

其中保存图片功能需要写入相册权限支持。

## 语言资源

项目已包含中英文资源，默认资源位于 `entry/src/main/resources/base/`，中文资源位于 `entry/src/main/resources/zh_CN/`。

## 许可证

项目包配置中当前声明为 `LGPL-3.0`，如需对外发布，请确认你的分发方式符合对应许可证要求。