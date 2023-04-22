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
  final controller = CodeController(
    text: 'print("Hello, world!")',
    language: javascript,
  );

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  void _openSubmissionsPage(BuildContext context) {
    context.go('/submissions');
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
            controller: controller,
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
