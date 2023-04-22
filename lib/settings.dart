import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings with ChangeNotifier {
  AppSettings._create({
    required SharedPreferences prefs,
    required bool isDarkMode,
    required String serverUrl,
    required double textScale,
  })  : _prefs = prefs,
        _isDarkMode = isDarkMode,
        _serverUrl = serverUrl,
        _textScale = textScale;

  final SharedPreferences _prefs;
  bool _isDarkMode;
  String _serverUrl;
  double _textScale;

  static Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();

    return AppSettings._create(
      prefs: prefs,
      isDarkMode: prefs.getBool('isDarkMode') ?? true,
      serverUrl: prefs.getString('serverUrl') ?? 'http://localhost:8000',
      textScale: prefs.getDouble('textScale') ?? 1.0,
    );
  }

  bool get isDarkMode => _isDarkMode;
  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
    _prefs.setBool('isDarkMode', _isDarkMode);
  }

  String get serverUrl => _serverUrl;
  set serverUrl(String value) {
    _serverUrl = value;
    notifyListeners();
    _prefs.setString('serverUrl', _serverUrl);
  }

  double get textScale => _textScale;
  set textScale(double value) {
    _textScale = value;
    notifyListeners();
    _prefs.setDouble('textScale', _textScale);
  }
}
