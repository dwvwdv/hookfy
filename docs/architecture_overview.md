# Hookfy 架構概覽

## 技術棧

- **前端**: Flutter (Dart) + Material Design 3
- **狀態管理**: Provider 6.1.1
- **數據庫**: SQLite (`sqflite: ^2.3.2`)
- **配置存儲**: SharedPreferences
- **後台服務**: flutter_foreground_task + workmanager
- **網絡**: http (Webhook)
- **原生層**: Kotlin (Android)

## 架構圖

```
┌─────────────────────────────────────────────────────┐
│                UI Layer (Flutter)                    │
│   HomePage | SettingsPage | AppSelectionPage        │
│                      │                               │
│               ┌──────▼──────┐                       │
│               │  Providers  │                       │
└───────────────┴──────┬──────┴───────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│              Service Layer (Dart)                    │
│  NotificationService | WebhookService               │
│  DatabaseService | PreferencesService               │
└──────────────────────┬──────────────────────────────┘
                       │ EventChannel
┌──────────────────────▼──────────────────────────────┐
│            Native Layer (Kotlin)                     │
│  NotificationListener (Service) | BootReceiver      │
└─────────────────────────────────────────────────────┘
```

## 數據流

```
系統通知 → NotificationListener.kt
    ↓ (應用過濾 + 保存 SQLite)
    ↓ (EventChannel 廣播)
NotificationService.dart
    ↓ (Stream 通知 UI)
    ↓ (Webhook 發送)
外部服務器
```

## Webhook 數據格式

```json
{
  "type": "notification",
  "timestamp": "2025-11-21T12:34:56.789Z",
  "data": {
    "packageName": "com.example.app",
    "appName": "Example App",
    "title": "標題",
    "text": "內容",
    "timestamp": 1732191296789
  }
}
```

## 數據庫結構

**表**: `notifications`
```sql
CREATE TABLE notifications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  package_name TEXT NOT NULL,
  app_name TEXT NOT NULL,
  title TEXT NOT NULL,
  text TEXT NOT NULL,
  sub_text TEXT,
  big_text TEXT,
  timestamp INTEGER NOT NULL,
  key TEXT
);
```

**索引**: `idx_timestamp` (DESC), `idx_package_name`
