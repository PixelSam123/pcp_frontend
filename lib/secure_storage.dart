import 'package:flutter/material.dart';

class SecureStorage with ChangeNotifier {
  SecureStorage._create({
    // required FlutterSecureStorage storage,
    required String? loginToken,
  }) : _loginToken = loginToken;

  // final FlutterSecureStorage _storage;
  String? _loginToken;

  static Future<SecureStorage> load() async {
    // final storage = FlutterSecureStorage();
    return SecureStorage._create(
      // storage: storage,
      // REPLACE WITH -> loginToken: await storage.read(key: 'loginToken'),
      loginToken: null,
    );
  }

  String? get loginToken => _loginToken;
  set loginToken(String? value) {
    _loginToken = value;
    notifyListeners();
    // _storage.write(key: 'loginToken', value: _loginToken);
  }
}
