# Release Guide

本文檔說明如何使用 GitHub Actions 自動生成和發布 APK。

## 自動發布流程

### 方式一：透過 Git Tag 自動發布（推薦）

1. 更新版本號（在 `pubspec.yaml` 中）：
   ```yaml
   version: 1.0.1+2  # 格式：版本號+構建號
   ```

2. 提交更改：
   ```bash
   git add pubspec.yaml
   git commit -m "chore: bump version to 1.0.1"
   ```

3. 建立並推送 tag：
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```

4. GitHub Actions 會自動：
   - 構建 release APK
   - 建立 GitHub Release
   - 上傳 APK 到 Release

### 方式二：手動觸發構建

1. 前往 GitHub 儲存庫的 Actions 頁面
2. 選擇「Build and Release APK」workflow
3. 點擊「Run workflow」
4. 輸入版本標籤（可選，如 `v1.0.1`）
5. 點擊運行

手動構建的 APK 會作為 Artifact 儲存 30 天，可在 workflow 運行頁面下載。

## CI/CD Workflows

### 1. Build and Release APK (release-apk.yml)
- **觸發條件**：推送 tag (v*) 或手動觸發
- **功能**：
  - 構建 release APK
  - 自動建立 GitHub Release（tag 觸發時）
  - 上傳 APK 到 Release 或 Artifacts

### 2. Build Check (build-check.yml)
- **觸發條件**：PR 或推送到 main/master 分支
- **功能**：
  - 程式碼分析
  - 運行測試
  - 構建 debug APK
  - 確保程式碼品質

## 版本管理建議

- 使用語義化版本：`MAJOR.MINOR.PATCH`
  - MAJOR: 重大更新，不相容的 API 變更
  - MINOR: 新功能，向後相容
  - PATCH: Bug 修復

- 構建號（`+` 後的數字）每次構建遞增

## 下載 APK

### 從 GitHub Releases
1. 前往儲存庫的 [Releases](../../releases) 頁面
2. 找到對應版本
3. 下載 `hookfy-v*.apk` 檔案

### 從 Actions Artifacts（手動構建）
1. 前往 [Actions](../../actions) 頁面
2. 選擇對應的 workflow run
3. 在 Artifacts 部分下載 APK

## 簽名說明

目前配置使用 debug 簽名用於快速發布。

**生產環境建議**：配置正式的 release 簽名
1. 生成 keystore
2. 將簽名資訊新增到 GitHub Secrets
3. 修改 workflow 使用正式簽名

詳見：[官方文檔](https://docs.flutter.dev/deployment/android#signing-the-app)
