# Hookfy

一個使用 Flutter 開發的 Android 通知監測應用，支援 Webhook 推送功能。

## 功能特性

1. **通知監測** - 監測 Android 手機上的所有應用通知
2. **Webhook 推送** - 當監測到新通知時，自動傳送 HTTP 請求到指定的 Webhook URL
3. **後台運行** - 支援後台持續運行，即使應用關閉也能繼續監測
4. **應用篩選** - 可以選擇監測所有應用或僅監測特定應用
5. **本地儲存** - 所有通知都會儲存到本地資料庫
6. **易於擴展** - 使用 Flutter 開發，後續可輕鬆擴展到 iOS 平台

## 系統要求

- Android 6.0 (API 23) 或更高版本
- 需要授予通知存取權限

## 下載 APK

### 從 GitHub Releases 下載（推薦）

前往 [Releases](../../releases) 頁面下載最新版本的 APK 檔案，直接安裝到 Android 裝置即可。

## 開發者指南

### 自動構建和發布

本專案配置了 GitHub Actions CI/CD，可自動構建和發布 APK。詳見 [RELEASE.md](RELEASE.md)。

**快速發布新版本**：
```bash
# 1. 更新版本號（編輯 pubspec.yaml）
# 2. 建立並推送 tag
git tag v1.0.1
git push origin v1.0.1
# 3. GitHub Actions 會自動構建並發布 APK
```

### 從原始碼構建

### 1. 複製專案

```bash
git clone <repository-url>
cd hookfy
```

### 2. 安裝依賴

```bash
flutter pub get
```

### 3. 運行應用

```bash
flutter run
```

### 4. 授予權限

首次運行時，應用會提示您授予通知存取權限。請按照以下步驟操作：

1. 點擊「Grant Permission」按鈕
2. 在系統設定中找到「Hookfy」
3. 開啟通知存取權限

### 5. 配置 Webhook

1. 開啟應用設定頁面
2. 輸入您的 Webhook URL（例如：`https://your-server.com/webhook`）
3. 開啟「Enable Webhook」開關
4. 可選：點擊「Test Webhook」測試連接

## Webhook 資料格式

當檢測到新通知時，應用會傳送以下格式的 JSON 資料到您的 Webhook URL：

```json
{
  "type": "notification",
  "timestamp": "2025-11-17T12:34:56.789Z",
  "data": {
    "packageName": "com.example.app",
    "appName": "Example App",
    "title": "Notification Title",
    "text": "Notification text content",
    "subText": "Optional sub text",
    "bigText": "Optional big text",
    "timestamp": 1700227696789,
    "timestampISO": "2025-11-17T12:34:56.789Z"
  }
}
```

## 應用篩選

### 監測所有應用

預設情況下，應用會監測所有應用的通知。

### 監測特定應用

1. 進入設定頁面
2. 關閉「Monitor All Apps」開關
3. 點擊「Select Apps」
4. 選擇您想要監測的應用

## 後台運行

應用支援後台持續運行：

1. 在設定中開啟「Run in Background」
2. 應用會在通知欄顯示一個前台服務通知
3. 即使關閉應用，通知監測仍會繼續

## 專案結構

```
lib/
├── models/           # 資料模型
│   ├── notification_model.dart
│   └── app_config.dart
├── services/         # 服務層
│   ├── notification_service.dart
│   ├── database_service.dart
│   ├── preferences_service.dart
│   ├── webhook_service.dart
│   └── background_service.dart
├── providers/        # 狀態管理
│   ├── settings_provider.dart
│   └── app_config_provider.dart
├── pages/           # UI 頁面
│   ├── home_page.dart
│   ├── settings_page.dart
│   └── app_selection_page.dart
└── main.dart        # 入口檔案

android/
└── app/src/main/kotlin/com/lazyrhythm/hookfy/
    ├── MainActivity.kt
    ├── NotificationListener.kt  # 通知監聽服務
    └── BootReceiver.kt         # 開機自啟動
```

## 技術棧

- **Flutter** - 跨平台 UI 框架
- **Provider** - 狀態管理
- **SQLite** - 本地資料庫
- **SharedPreferences** - 配置儲存
- **HTTP** - Webhook 請求
- **WorkManager & Foreground Task** - 後台服務

## 權限說明

應用需要以下權限：

- **通知存取權限** - 用於監測其他應用的通知
- **網路權限** - 用於傳送 Webhook 請求
- **前台服務權限** - 用於後台持續運行
- **開機自啟動權限** - 用於系統重啟後自動啟動服務

## 隱私和安全

- 所有通知資料僅儲存在本地裝置
- Webhook URL 和配置資訊儲存在本地
- 應用不會收集或上傳任何使用者資料到第三方伺服器
- 通知資料僅在啟用 Webhook 功能時傳送到使用者指定的 URL

## 開發計畫

- [ ] iOS 版本支援
- [ ] 自訂 Webhook 請求標頭
- [ ] 通知過濾規則
- [ ] 資料匯出功能
- [ ] 通知統計和分析

## 許可證

MIT License

## 貢獻

歡迎提交 Issue 和 Pull Request！