import 'package:flutter/material.dart';

class SecureStorage with ChangeNotifier {
  SecureStorage._create({
    // required FlutterSecureStorage storage,
    required String? loginToken,
    required int? userId,
  })  : _loginToken = loginToken,
        _userId = userId;

  // final FlutterSecureStorage _storage;
  String? _loginToken;
  int? _userId;

  static Future<SecureStorage> load() async {
    // final storage = FlutterSecureStorage();
    return SecureStorage._create(
      // storage: storage,
      // REPLACE WITH -> loginToken: await storage.read(key: 'loginToken'),
      loginToken: null,
      // REPLACE WITH -> loginToken: int.parse(await storage.read(key: 'userId')),
      userId: null,
    );
  }

  String? get loginToken => _loginToken;
  set loginToken(String? value) {
    _loginToken = value;
    notifyListeners();
    // _storage.write(key: 'loginToken', value: _loginToken);
  }

  int? get userId => _userId;
  set userId(int? value) {
    _userId = value;
    notifyListeners();
    // _storage.write(key: 'userId', value: _userId.toString());
  }
}
