import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pcp_frontend/components/page_layout.dart';
import 'package:pcp_frontend/secure_storage.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:pcp_frontend/types/user.dart';
import 'package:pcp_frontend/types/access_token.dart';
import 'package:pcp_frontend/utils.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _logout(BuildContext context) {
    context.read<SecureStorage>().loginToken = null;
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Login/Sign Up',
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
  Future<UserReadBrief>? _userResponse;

  Future<AccessTokenResponse> _fetchToken() async {
    final appSettings = context.read<AppSettings>();

    final tokenResponse = await FetchUtils.post(
      '${appSettings.serverUrl}/token/',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      failMessage: 'Failed to fetch token (log in)',
      body: {
        'username': _username.text,
        'password': _password.text,
      },
    );

    return AccessTokenResponse.fromJson(jsonDecode(tokenResponse));
  }

  Future<UserReadBrief> _postUser() async {
    final appSettings = context.read<AppSettings>();

    final userResponse = await FetchUtils.post(
      '${appSettings.serverUrl}/users/',
      headers: {'Content-Type': 'application/json'},
      failMessage: 'Failed to create user',
      body: jsonEncode({
        'name': _username.text,
        'password': _password.text,
      }),
    );

    return UserReadBrief.fromJson(jsonDecode(userResponse));
  }

  Future<void> _login() async {
    final token = _fetchToken();
    setState(() {
      _tokenResponse = token;
    });

    final secureStorage = context.read<SecureStorage>();
    final accessToken = (await token).accessToken;

    secureStorage.loginToken = accessToken;
  }

  Future<void> _signUp() async {
    final user = _postUser();
    setState(() {
      _userResponse = user;
    });

    await user;
    await _login();
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
          const SizedBox(height: PadSize.md),
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
          OutlinedButton(
            onPressed: _signUp,
            child: const Text('Sign Up'),
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
          const SizedBox(height: PadSize.sm),
          _userResponse == null
              ? const Text('Waiting for sign up...')
              : FutureBuilder(
                  future: _userResponse,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (!snapshot.hasData) {
                      return const Text('Signing up...');
                    }

                    return const Text('You are signed up!');
                  },
                ),
        ],
      ),
    );
  }
}
