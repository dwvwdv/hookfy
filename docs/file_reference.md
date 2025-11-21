# Hookfy 文件參考

## 目錄結構

```
hookfy/
├── android/app/src/main/kotlin/com/lazyrhythm/hookfy/
│   ├── MainActivity.kt              # Flutter Activity
│   ├── NotificationListener.kt      # 通知監聽服務 ⭐
│   └── BootReceiver.kt              # 開機自啟動
│
├── lib/
│   ├── models/
│   │   ├── notification_model.dart  # 通知數據模型 ⭐
│   │   └── app_config.dart          # 應用配置模型
│   │
│   ├── services/
│   │   ├── notification_service.dart # 通知事件管理 ⭐
│   │   ├── database_service.dart     # SQLite 操作 ⭐
│   │   ├── preferences_service.dart  # 配置管理
│   │   ├── webhook_service.dart      # Webhook 發送 ⭐
│   │   └── background_service.dart   # 後台服務
│   │
│   ├── providers/
│   │   ├── settings_provider.dart    # 設置狀態
│   │   └── app_config_provider.dart  # 應用配置狀態
│   │
│   ├── pages/
│   │   ├── home_page.dart            # 通知列表主頁 ⭐
│   │   ├── settings_page.dart        # 設置頁面
│   │   └── app_selection_page.dart   # 應用選擇頁面
│   │
│   └── main.dart                     # 應用入口
│
├── docs/                             # 開發文檔
├── pubspec.yaml                      # Flutter 依賴
└── CLAUDE.md                         # AI 開發索引

⭐ = 核心文件
```

## 關鍵文件說明

### NotificationListener.kt
- **路徑**: `android/app/src/main/kotlin/.../NotificationListener.kt`
- **作用**: 監聽系統通知、應用過濾、保存數據庫、EventChannel 廣播

### notification_service.dart
- **路徑**: `lib/services/notification_service.dart`
- **作用**: 接收通知事件流、調用 Webhook、通知 UI 更新

### database_service.dart
- **路徑**: `lib/services/database_service.dart`
- **關鍵方法**:
  - `insertNotification()` - 插入
  - `getNotifications(limit, offset)` - 查詢
  - `deleteNotification(id)` - 刪除單條
  - `clearAllNotifications()` - 清空

### home_page.dart
- **路徑**: `lib/pages/home_page.dart`
- **功能**:
  - 通知列表 UI
  - 三種過濾模式 (detectingApp, showAll, custom)
  - Dismissible 滑動刪除
  - RefreshIndicator 下拉刷新
