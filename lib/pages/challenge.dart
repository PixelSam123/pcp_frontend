import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/ocean.dart';
import 'package:go_router/go_router.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:http/http.dart' as http;
import 'package:pcp_frontend/components.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/types.dart';
import 'package:provider/provider.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({
    super.key,
    required String challengeName,
  }) : _challengeName = challengeName;

  final String _challengeName;

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  late Future<ChallengeRead> _challenge;

  Future<ChallengeRead> _fetchChallenge() async {
    final appSettings = context.read<AppSettings>();
    final response = await http.get(
      Uri.parse('${appSettings.serverUrl}/challenges/${widget._challengeName}'),
    );

    if (response.statusCode == 200) {
      return ChallengeRead.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load challenge');
    }
  }

  @override
  void initState() {
    super.initState();

    _challenge = _fetchChallenge();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: widget._challengeName,
      child: FutureBuilder(
        future: _challenge,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return const Text('Loading challenge information...');
          }

          return _ChallengeView(challenge: snapshot.data!);
        },
      ),
    );
  }
}

class _ChallengeView extends StatefulWidget {
  const _ChallengeView({required ChallengeRead challenge})
      : _challenge = challenge;

  final ChallengeRead _challenge;

  @override
  State<_ChallengeView> createState() => _ChallengeViewState();
}

class _ChallengeViewState extends State<_ChallengeView> {
  final _codeToSubmit = CodeController(language: javascript);

  void _openSubmissionsPage(BuildContext context) {
    context.go('/submissions');
  }

  @override
  void initState() {
    super.initState();

    _codeToSubmit.text = widget._challenge.initialCode;
  }

  @override
  void dispose() {
    _codeToSubmit.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(widget._challenge.description),
      OutlinedButton(
        onPressed: () => _openSubmissionsPage(context),
        child: const Text('Open Submissions page'),
      ),
      CodeTheme(
        data: CodeThemeData(styles: oceanTheme),
        child: CodeField(
          controller: _codeToSubmit,
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontFamilyFallback: ['Consolas'],
          ),
        ),
      ),
    ]);
  }
}
