import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/app_config_provider.dart';
import 'app_selection_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final appConfigProvider = context.watch<AppConfigProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'App Monitoring',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Enable Webhook'),
            subtitle: const Text('Send notifications to webhook URLs'),
            value: settingsProvider.webhookEnabled,
            onChanged: (value) {
              settingsProvider.toggleWebhook(value);
            },
          ),
          ListTile(
            title: const Text('Select Apps'),
            subtitle: Text('${appConfigProvider.enabledAppCount} apps enabled'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppSelectionPage(),
                ),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Background Service',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Run in Background'),
            subtitle: const Text('Keep monitoring when app is closed'),
            value: settingsProvider.backgroundServiceEnabled,
            onChanged: (value) {
              settingsProvider.toggleBackgroundService(value);
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const ListTile(
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          const ListTile(
            title: Text('Description'),
            subtitle: Text(
              'Notifly monitors Android notifications and sends them to your webhook endpoint.',
            ),
          ),
        ],
      ),
    );
  }
}
