# Check-in Reminder

基于地理围栏和 Wi-Fi 的智能打卡提醒 Flutter 应用。

## 功能特性

- 🗺️ **地理围栏提醒** — 进入/离开公司区域时自动触发打卡提醒
- 📶 **Wi-Fi 感知** — 连接/断开公司 Wi-Fi 时触发提醒
- 🔔 **本地通知** — 无需网络、无后端的纯本地方案
- 📊 **打卡记录** — 记录并统计每日上下班时间
- 🗓️ **节假日支持** — 自动识别法定节假日，避免误报
- 📱 **桌面小组件** — 主屏幕快捷查看状态
- 🌍 **国际化** — 支持中文/英文

## 技术栈

| 分类 | 技术 |
|------|------|
| 框架 | Flutter 3.x / Dart 3.x |
| 状态管理 | flutter_riverpod 3.x (Notifier) |
| 路由 | go_router 17.x |
| 本地存储 | hive_ce + hive_ce_flutter |
| 地图 | flutter_map + OpenStreetMap（无需 API Key） |
| 通知 | flutter_local_notifications 21.x |
| 地理围栏 | flutter_background_geolocation |
| Wi-Fi | network_info_plus |
| 桌面小组件 | home_widget |
| 国际化 | flutter_localizations + gen-l10n |

## 快速开始

### 环境要求

- Flutter 3.x / Dart 3.x
- iOS 14+ / Android 8+（API 26+）

### 安装运行

```bash
# 安装依赖
flutter pub get

# 生成国际化文件
flutter gen-l10n

# 生成代码（Freezed、Hive、JSON）
dart run build_runner build --delete-conflicting-outputs

# 运行（iOS 模拟器）
flutter build ios --simulator --debug

# 运行（Android）
flutter run
```

### iOS 额外步骤

```bash
cd ios && pod install
```

## 项目结构

```
lib/
├── core/          # 常量、主题、路由
├── models/        # Freezed 数据模型
├── services/      # 业务服务（存储/通知/地理围栏/Wi-Fi 等）
├── providers/     # Riverpod 状态管理
├── features/      # UI 页面（home/records/statistics/settings）
└── l10n/          # 国际化 ARB 文件
```

## 注意事项

- 纯本地应用，不依赖任何后端服务
- 地理围栏需要授予「始终允许」位置权限
- iOS WidgetKit 扩展需在 Xcode 中手动配置
