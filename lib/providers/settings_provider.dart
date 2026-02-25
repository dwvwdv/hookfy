// Copyright (C) 2025 hookfy Contributors
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/foundation.dart';
import '../services/preferences_service.dart';
import '../services/background_service.dart';
import '../services/webhook_service.dart';

class SettingsProvider extends ChangeNotifier {
  String _webhookUrl = '';
  bool _webhookEnabled = false;
  bool _backgroundServiceEnabled = true;
  Map<String, String> _webhookHeaders = {};
  bool _swipeToDeleteEnabled = true;

  String get webhookUrl => _webhookUrl;
  bool get webhookEnabled => _webhookEnabled;
  bool get backgroundServiceEnabled => _backgroundServiceEnabled;
  Map<String, String> get webhookHeaders => _webhookHeaders;
  bool get swipeToDeleteEnabled => _swipeToDeleteEnabled;

  Future<void> init() async {
    await loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = PreferencesService.instance;
    _webhookUrl = prefs.getWebhookUrl() ?? '';
    _webhookEnabled = prefs.getWebhookEnabled();
    _backgroundServiceEnabled = prefs.getBackgroundServiceEnabled();
    _webhookHeaders = prefs.getWebhookHeaders();
    _swipeToDeleteEnabled = prefs.getSwipeToDeleteEnabled();
    notifyListeners();
  }

  Future<void> setWebhookUrl(String url) async {
    _webhookUrl = url;
    await PreferencesService.instance.setWebhookUrl(url);
    notifyListeners();
  }

  Future<void> toggleWebhook(bool enabled) async {
    _webhookEnabled = enabled;
    await PreferencesService.instance.setWebhookEnabled(enabled);
    notifyListeners();
  }

  Future<void> toggleBackgroundService(bool enabled) async {
    _backgroundServiceEnabled = enabled;
    await PreferencesService.instance.setBackgroundServiceEnabled(enabled);

    if (enabled) {
      await BackgroundService.instance.startService();
    } else {
      await BackgroundService.instance.stopService();
    }

    notifyListeners();
  }

  Future<void> setWebhookHeaders(Map<String, String> headers) async {
    _webhookHeaders = headers;
    await PreferencesService.instance.setWebhookHeaders(headers);
    notifyListeners();
  }

  Future<bool> testWebhook() async {
    if (_webhookUrl.isEmpty) return false;

    return await WebhookService.instance.testWebhook(
      _webhookUrl,
      headers: _webhookHeaders,
    );
  }

  Future<void> toggleSwipeToDelete(bool enabled) async {
    _swipeToDeleteEnabled = enabled;
    await PreferencesService.instance.setSwipeToDeleteEnabled(enabled);
    notifyListeners();
  }
}
