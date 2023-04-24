import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SecureStorage with ChangeNotifier {
  SecureStorage._create({
    // required FlutterSecureStorage storage,
    required String? loginToken,
  }) : _loginToken = loginToken;

  // final FlutterSecureStorage _storage;
  String? _loginToken;
  int? _userId;
  String? _userName;

  static Future<SecureStorage> load() async {
    // final underlyingStorage = FlutterSecureStorage();
    return SecureStorage._create(
      // storage: storage,
      // REPLACE WITH -> loginToken: await storage.read(key: 'loginToken'),
      loginToken: null,
    );
  }

  String? get loginToken => _loginToken;
  set loginToken(String? value) {
    _loginToken = value;

    _userId = value != null ? int.parse(JwtDecoder.decode(value)['sub']) : null;
    _userName = value != null ? JwtDecoder.decode(value)['name'] : null;
    notifyListeners();
    // _storage.write(key: 'loginToken', value: _loginToken);
  }

  int? get userId => _userId;
  String? get userName => _userName;
}
