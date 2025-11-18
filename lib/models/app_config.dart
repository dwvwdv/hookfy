class AppConfig {
  final String packageName;
  final String appName;
  final bool isEnabled;
  final List<String> webhookUrls;

  AppConfig({
    required this.packageName,
    required this.appName,
    required this.isEnabled,
    List<String>? webhookUrls,
  }) : webhookUrls = webhookUrls ?? [];

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      isEnabled: json['isEnabled'] as bool,
      webhookUrls: json['webhookUrls'] != null
          ? List<String>.from(json['webhookUrls'] as List)
          : (json['webhookUrl'] != null ? [json['webhookUrl'] as String] : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'isEnabled': isEnabled,
      'webhookUrls': webhookUrls,
    };
  }

  AppConfig copyWith({
    String? packageName,
    String? appName,
    bool? isEnabled,
    List<String>? webhookUrls,
  }) {
    return AppConfig(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      isEnabled: isEnabled ?? this.isEnabled,
      webhookUrls: webhookUrls ?? this.webhookUrls,
    );
  }
}
