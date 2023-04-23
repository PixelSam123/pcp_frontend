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

  void _setIsDarkMode(bool value) {
    final appSettings = context.read<AppSettings>();
    appSettings.isDarkMode = value;
  }

  void _setServerUrl(String value) {
    final appSettings = context.read<AppSettings>();
    appSettings.serverUrl = value;
  }

  void _setTextScale(String value) {
    final appSettings = context.read<AppSettings>();
    appSettings.textScale = double.parse(value);
  }

  @override
  void initState() {
    super.initState();

    final appSettings = context.read<AppSettings>();
    _serverUrl.text = appSettings.serverUrl;
    _textScale.text = appSettings.textScale.toString();
  }

  @override
  void dispose() {
    _serverUrl.dispose();
    _textScale.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Settings',
      child: Column(children: [
        Row(children: [
          const Text('Dark mode'),
          Switch(
            value: context.select((AppSettings s) => s.isDarkMode),
            onChanged: _setIsDarkMode,
          ),
        ]),
        const SizedBox(height: PadSize.sm),
        TextField(
          controller: _serverUrl,
          onChanged: _setServerUrl,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            labelText: 'Server URL',
          ),
        ),
        const SizedBox(height: PadSize.md),
        TextField(
          controller: _textScale,
          onChanged: _setTextScale,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            labelText: 'Text Scale',
          ),
        ),
      ]),
    );
  }
}
