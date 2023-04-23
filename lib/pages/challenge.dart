import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/ocean.dart';
import 'package:go_router/go_router.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:pcp_frontend/components.dart';
import 'package:pcp_frontend/secure_storage.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:pcp_frontend/types.dart';
import 'package:pcp_frontend/utils.dart';
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

class _ChallengePageState extends State<ChallengePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var _tabIndex = 0;

  late Future<ChallengeRead> _challenge;
  late Future<List<ChallengeCommentRead>> _comments;

  Future<ChallengeRead> _fetchChallenge() async {
    final appSettings = context.read<AppSettings>();

    final challenge = await FetchUtils.get(
      '${appSettings.serverUrl}/challenges/${widget._challengeName}',
      failMessage: 'Failed to load challenge',
    );

    return ChallengeRead.fromJson(jsonDecode(challenge));
  }

  Future<List<ChallengeCommentRead>> _fetchComments() async {
    final appSettings = context.read<AppSettings>();

    final comments = await FetchUtils.get(
        '${appSettings.serverUrl}/challenge_comments/'
        '?challenge_name=${widget._challengeName}',
        failMessage: 'Failed to load challenge comments');

    return (jsonDecode(comments) as List)
        .map<ChallengeCommentRead>(
          (comment) => ChallengeCommentRead.fromJson(comment),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();

    _challenge = _fetchChallenge();
    _comments = _fetchComments();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: widget._challengeName,
      child: Column(children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Description'),
            Tab(text: 'Comments'),
          ],
        ),
        _tabIndex == 0
            ? FutureBuilder(
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
              )
            : FutureBuilder(
                future: _comments,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (!snapshot.hasData) {
                    return const Text('Loading challenge comments...');
                  }

                  return _CommentsView(comments: snapshot.data!);
                },
              ),
      ]),
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

  Future<SubmissionRead>? _submissionResponse;

  void _openSubmissionsPage(BuildContext context) {
    context.go('/submissions/${widget._challenge.name}');
  }

  Future<SubmissionRead> _postSubmission() async {
    final appSettings = context.read<AppSettings>();
    final secureStorage = context.read<SecureStorage>();

    final submissionResponse = await FetchUtils.post(
      '${appSettings.serverUrl}/submissions/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${secureStorage.loginToken}',
      },
      failMessage: 'Failed to create submission for challenge',
      body: jsonEncode({
        'code': _codeToSubmit.text,
        'result': 'PENDING',
        'time': 0,
        'memory': 0,
        'user_id': secureStorage.userId,
        'challenge_id': widget._challenge.id,
      }),
    );

    return SubmissionRead.fromJson(jsonDecode(submissionResponse));
  }

  void _sendPostRequest() {
    setState(() {
      _submissionResponse = _postSubmission();
    });
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
      const SizedBox(height: PadSize.md),
      Text(widget._challenge.description),
      const SizedBox(height: PadSize.md),
      OutlinedButton(
        onPressed: () => _openSubmissionsPage(context),
        child: const Text('Open Submissions page'),
      ),
      const SizedBox(height: PadSize.md),
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
      const SizedBox(height: PadSize.md),
      ElevatedButton(
        onPressed: _sendPostRequest,
        child: const Text('Submit'),
      ),
      const SizedBox(height: PadSize.md),
      _submissionResponse == null
          ? const Text('No submission sent yet')
          : FutureBuilder(
              future: _submissionResponse,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return const Text(
                    'Submitting your attempt for this challenge...',
                  );
                }

                return const Text('Successfully created submission!');
              },
            ),
    ]);
  }
}

class _CommentsView extends StatelessWidget {
  const _CommentsView({required List<ChallengeCommentRead> comments})
      : _comments = comments;

  final List<ChallengeCommentRead> _comments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _comments
          .map(
            (comment) => Card(
              child: Column(children: [
                UserButton(
                  user: comment.user,
                  onPressed: () {},
                ),
                Text(comment.content),
              ]),
            ),
          )
          .toList(),
    );
  }
}
