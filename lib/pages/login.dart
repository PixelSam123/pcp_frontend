import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pcp_frontend/components.dart';
import 'package:pcp_frontend/secure_storage.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:pcp_frontend/types.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _logout(BuildContext context) {
    context.read<SecureStorage>().loginToken = null;
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Login',
      child: Column(children: [
        context.select((SecureStorage s) => s.loginToken) == null
            ? const _CredentialsForm()
            : Column(children: [
                const Text('You are logged in!'),
                const SizedBox(height: PadSize.sm),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  child: const Text('Log out'),
                ),
              ]),
      ]),
    );
  }
}

class _CredentialsForm extends StatefulWidget {
  const _CredentialsForm();

  @override
  State<_CredentialsForm> createState() => _CredentialsFormState();
}

class _CredentialsFormState extends State<_CredentialsForm> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  Future<AccessTokenResponse>? _tokenResponse;

  Future<AccessTokenResponse> _fetchToken() async {
    final appSettings = context.read<AppSettings>();
    final response = await http.post(
      Uri.parse('${appSettings.serverUrl}/token/'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': _username.text,
        'password': _password.text,
      },
    );

    if (response.statusCode == 200) {
      return AccessTokenResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch token (log in):\n${response.body}');
    }
  }

  Future<void> _login() async {
    final token = _fetchToken();
    setState(() {
      _tokenResponse = token;
    });

    final secureStorage = context.read<SecureStorage>();
    final accessToken = (await token).accessToken;

    secureStorage.loginToken = accessToken;
    secureStorage.userId = int.parse(JwtDecoder.decode(accessToken)['sub']);
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _username,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: PadSize.md),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: PadSize.md),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Login'),
          ),
          const SizedBox(height: PadSize.md),
          _tokenResponse == null
              ? const Text('Waiting for login...')
              : FutureBuilder(
                  future: _tokenResponse,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (!snapshot.hasData) {
                      return const Text('Logging in...');
                    }

                    return const Text('You are logged in!');
                  },
                ),
        ],
      ),
    );
  }
}
