# Hookfy 代碼庫總結

## 項目概覽

**Hookfy** 是一個 Flutter Android 通知監測應用，支援 Webhook 推送。

- **版本**: 1.0.2+3
- **最低 Android**: API 23 (6.0)
- **Flutter SDK**: >=3.3.0 <4.0.0

## 核心功能

1. **通知監測** - 實時監測系統通知
2. **Webhook 推送** - 全局 + 應用級別多 Webhook
3. **後台運行** - 前台服務持續運行
4. **本地存儲** - SQLite 通知歷史
5. **應用篩選** - 白名單/監測模式
6. **滑動刪除** - 左右滑動刪除通知記錄

## 最近更新

### v1.0.2+3 (2025-11-21)
- 新增通知列表滑動刪除功能
- SnackBar 確認 + 復原功能

### v1.0.2 (2025-11-20)
- 過濾系統級應用通知
- 配置 Android 發布簽名
- 簡體中文轉繁體中文

## 開發快速參考

```bash
# 運行
flutter run

# 構建
flutter build apk --release

# 分析
flutter analyze

# 清理
flutter clean && flutter pub get
```

## Git 工作流

```bash
# 功能分支
git checkout -b claude/feature-name-<session-id>

# 提交規範
feat: 新功能
fix: Bug 修復
docs: 文檔更新

# 發布
git tag v1.0.3
git push origin v1.0.3
```

## 權限需求

- 通知存取權限 - 監測通知
- 網路權限 - Webhook
- 前台服務權限 - 後台運行
- 開機自啟動 - 自動啟動服務
