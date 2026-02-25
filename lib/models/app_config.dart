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

import 'filter_condition.dart';

class AppConfig {
  final String packageName;
  final String appName;
  final bool isEnabled;
  final List<String> webhookUrls;
  final List<FilterRule> filterRules; // 進階過濾條件

  AppConfig({
    required this.packageName,
    required this.appName,
    required this.isEnabled,
    List<String>? webhookUrls,
    List<FilterRule>? filterRules,
  }) : webhookUrls = webhookUrls ?? [],
       filterRules = filterRules ?? [];

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      isEnabled: json['isEnabled'] as bool,
      webhookUrls: json['webhookUrls'] != null
          ? List<String>.from(json['webhookUrls'] as List)
          : (json['webhookUrl'] != null ? [json['webhookUrl'] as String] : null),
      filterRules: json['filterRules'] != null
          ? (json['filterRules'] as List)
              .map((r) => FilterRule.fromJson(r))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'isEnabled': isEnabled,
      'webhookUrls': webhookUrls,
      'filterRules': filterRules.map((r) => r.toJson()).toList(),
    };
  }

  AppConfig copyWith({
    String? packageName,
    String? appName,
    bool? isEnabled,
    List<String>? webhookUrls,
    List<FilterRule>? filterRules,
  }) {
    return AppConfig(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      isEnabled: isEnabled ?? this.isEnabled,
      webhookUrls: webhookUrls ?? this.webhookUrls,
      filterRules: filterRules ?? this.filterRules,
    );
  }
}
