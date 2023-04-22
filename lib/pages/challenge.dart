import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/ocean.dart';
import 'package:go_router/go_router.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:pcp_frontend/components.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final _codeToSubmit = CodeController(
    text: 'console.log(\'hello world\')',
    language: javascript,
  );

  void _openSubmissionsPage(BuildContext context) {
    context.go('/submissions');
  }

  @override
  void dispose() {
    _codeToSubmit.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Challenge #1',
      child: Column(children: [
        const Text('Challenge page\nPretend this is a nice description'),
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
      ]),
    );
  }
}
