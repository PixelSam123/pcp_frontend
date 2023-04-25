import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/ocean.dart';
import 'package:go_router/go_router.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:pcp_frontend/components/page_layout.dart';
import 'package:pcp_frontend/components/user_button.dart';
import 'package:pcp_frontend/secure_storage.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:pcp_frontend/types/challenge.dart';
import 'package:pcp_frontend/types/challenge_comment.dart';
import 'package:pcp_frontend/types/submission.dart';
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

  void _refreshComments() {
    setState(() {
      _comments = _fetchComments();
    });
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
        FutureBuilder(
          future: _challenge,
          builder: (context, challengeSnapshot) {
            if (challengeSnapshot.hasError) {
              return Text(challengeSnapshot.error.toString());
            }
            if (!challengeSnapshot.hasData) {
              return const Text('Loading challenge information...');
            }

            return _tabIndex == 0
                ? _ChallengeView(challenge: challengeSnapshot.data!)
                : FutureBuilder(
                    future: _comments,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (!snapshot.hasData) {
                        return const Text('Loading challenge comments...');
                      }

                      return _CommentsView(
                        challengeId: challengeSnapshot.data!.id,
                        comments: snapshot.data!,
                        onCommentPosted: _refreshComments,
                      );
                    },
                  );
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
    context.push('/submissions/${widget._challenge.name}');
  }

  Future<SubmissionRead> _postSubmission() async {
    final appSettings = context.read<AppSettings>();
    final secureStorage = context.read<SecureStorage>();

    final submissionResponse = await FetchUtils.post(
      '${appSettings.serverUrl}/submissions',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${secureStorage.loginToken}',
      },
      failMessage: 'Failed to create submission for challenge',
      body: jsonEncode({
        'code': _codeToSubmit.text,
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
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tier:',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: PadSize.sm),
          Text(widget._challenge.tier.toString()),
          const SizedBox(width: PadSize.lg),
          Text(
            'Author:',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          UserButton(user: widget._challenge.user),
        ],
      ),
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
                  return Text(
                    snapshot.error.toString().replaceAll('\\n', '\n'),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontFamilyFallback: ['Consolas'],
                    ),
                  );
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

class _CommentsView extends StatefulWidget {
  const _CommentsView({
    required int challengeId,
    required List<ChallengeCommentRead> comments,
    required VoidCallback onCommentPosted,
  })  : _challengeId = challengeId,
        _comments = comments,
        _onCommentPosted = onCommentPosted;

  final int _challengeId;
  final List<ChallengeCommentRead> _comments;
  final VoidCallback _onCommentPosted;

  @override
  State<_CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<_CommentsView> {
  final _commentContent = TextEditingController();

  Future<ChallengeCommentRead>? _commentResponse;

  Future<ChallengeCommentRead> _postComment() async {
    final appSettings = context.read<AppSettings>();
    final secureStorage = context.read<SecureStorage>();

    final commentResponse = await FetchUtils.post(
      '${appSettings.serverUrl}/challenge_comments',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${secureStorage.loginToken}',
      },
      failMessage: 'Failed to create comment for challenge',
      body: jsonEncode({
        'content': _commentContent.text,
        'user_id': secureStorage.userId,
        'challenge_id': widget._challengeId,
      }),
    );

    return ChallengeCommentRead.fromJson(jsonDecode(commentResponse));
  }

  Future<void> _sendPostRequest() async {
    final commentResponse = _postComment();
    setState(() {
      _commentResponse = commentResponse;
    });

    await commentResponse;
    _commentContent.clear();
    widget._onCommentPosted();
  }

  @override
  void dispose() {
    _commentContent.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: PadSize.md),
        TextField(
          controller: _commentContent,
          keyboardType: TextInputType.multiline,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            labelText: 'Write your comment',
          ),
        ),
        const SizedBox(height: PadSize.md),
        ElevatedButton(
          onPressed: _sendPostRequest,
          child: const Text('Submit'),
        ),
        const SizedBox(height: PadSize.md),
        _commentResponse == null
            ? const Text('No comment sent yet')
            : FutureBuilder(
                future: _commentResponse,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (!snapshot.hasData) {
                    return const Text(
                      'Submitting your comment for this challenge...',
                    );
                  }

                  return const Text('Successfully created comment!');
                },
              ),
        const SizedBox(height: PadSize.md),
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...widget._comments.map(
                (comment) => Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      PadSize.md,
                      PadSize.sm,
                      PadSize.md,
                      PadSize.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserButton(user: comment.user),
                        Text(comment.content),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
