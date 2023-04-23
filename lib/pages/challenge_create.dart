import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pcp_frontend/components.dart';
import 'package:pcp_frontend/secure_storage.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:pcp_frontend/types.dart';
import 'package:pcp_frontend/utils.dart';
import 'package:provider/provider.dart';

class ChallengeCreatePage extends StatefulWidget {
  const ChallengeCreatePage({super.key});

  @override
  State<ChallengeCreatePage> createState() => _ChallengeCreatePageState();
}

class _ChallengeCreatePageState extends State<ChallengeCreatePage> {
  final _name = TextEditingController();
  final _tier = TextEditingController();
  final _description = TextEditingController();
  final _initialCode = TextEditingController();
  final _testCase = TextEditingController();

  Future<ChallengeRead>? _challengeResponse;

  Future<ChallengeRead> _postChallenge() async {
    final appSettings = context.read<AppSettings>();
    final secureStorage = context.read<SecureStorage>();

    final challengeResponse = await FetchUtils.post(
      '${appSettings.serverUrl}/challenges/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${secureStorage.loginToken}',
      },
      failMessage: 'Failed to create challenge',
      body: jsonEncode({
        'name': _name.text,
        'tier': _tier.text,
        'user_id': secureStorage.userId,
        'description': _description.text,
        'initial_code': _initialCode.text,
        'test_case': _testCase.text,
      }),
    );

    return ChallengeRead.fromJson(jsonDecode(challengeResponse));
  }

  void _sendPostRequest() {
    setState(() {
      _challengeResponse = _postChallenge();
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _tier.dispose();
    _description.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Create Challenge',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              labelText: 'Name',
            ),
          ),
          const SizedBox(height: PadSize.md),
          TextField(
            controller: _tier,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              labelText: 'Tier',
            ),
          ),
          const SizedBox(height: PadSize.md),
          TextField(
            controller: _description,
            keyboardType: TextInputType.multiline,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              labelText: 'Description',
            ),
          ),
          const SizedBox(height: PadSize.md),
          TextField(
            controller: _initialCode,
            keyboardType: TextInputType.multiline,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              labelText: 'Initial Code',
            ),
          ),
          const SizedBox(height: PadSize.md),
          TextField(
            controller: _testCase,
            keyboardType: TextInputType.multiline,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              labelText: 'Test Case',
            ),
          ),
          const SizedBox(height: PadSize.md),
          ElevatedButton(
            onPressed: _sendPostRequest,
            child: const Text('Create'),
          ),
          const SizedBox(height: PadSize.md),
          _challengeResponse == null
              ? const Text('Waiting for creation...')
              : FutureBuilder(
                  future: _challengeResponse,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (!snapshot.hasData) {
                      return const Text('Submitting your new challenge...');
                    }

                    return const Text('Successfully created challenge!');
                  },
                ),
        ],
      ),
    );
  }
}
