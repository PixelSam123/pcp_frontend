import 'package:flutter/material.dart';
import 'package:pcp_frontend/components.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _serverUrl = TextEditingController();
  final _textScale = TextEditingController();

  void _setIsDarkMode(AppSettings appSettings, bool value) {
    appSettings.isDarkMode = value;
  }

  void _setServerUrl(AppSettings appSettings, String value) {
    appSettings.serverUrl = value;
  }

  void _setTextScale(AppSettings appSettings, String value) {
    appSettings.textScale = double.parse(value);
  }

  @override
  void initState() {
    super.initState();

    final currentAppSettings = context.read<AppSettings>();
    _serverUrl.text = currentAppSettings.serverUrl;
    _textScale.text = currentAppSettings.textScale.toString();
  }

  @override
  void dispose() {
    _serverUrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Settings',
      child: Consumer<AppSettings>(
        builder: (context, appSettings, child) {
          return Column(children: [
            Row(children: [
              const Text('Dark mode'),
              Switch(
                value: appSettings.isDarkMode,
                onChanged: (value) => _setIsDarkMode(appSettings, value),
              ),
            ]),
            const SizedBox(height: PadSize.small),
            TextField(
              controller: _serverUrl,
              onChanged: (value) => _setServerUrl(appSettings, value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Server URL',
              ),
            ),
            const SizedBox(height: PadSize.small),
            TextField(
              controller: _textScale,
              onChanged: (value) => _setTextScale(appSettings, value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Text Scale',
              ),
            ),
          ]);
        },
      ),
    );
  }
}
