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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/preferences_service.dart';
import 'services/notification_service.dart';
import 'services/background_service.dart';
import 'providers/settings_provider.dart';
import 'providers/app_config_provider.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await PreferencesService.instance.init();
  await NotificationService.instance.init();
  BackgroundService.instance.init();

  // Start background service if enabled
  if (PreferencesService.instance.getBackgroundServiceEnabled()) {
    await BackgroundService.instance.startService();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppConfigProvider()..init(),
        ),
      ],
      child: MaterialApp(
        title: 'Hookfy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
