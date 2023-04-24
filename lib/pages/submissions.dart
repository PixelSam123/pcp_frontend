import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pcp_frontend/components.dart';
import 'package:pcp_frontend/secure_storage.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/types/submission.dart';
import 'package:pcp_frontend/utils.dart';
import 'package:provider/provider.dart';

class SubmissionsPage extends StatefulWidget {
  const SubmissionsPage({
    super.key,
    required String challengeName,
  }) : _challengeName = challengeName;

  final String _challengeName;

  @override
  State<SubmissionsPage> createState() => _SubmissionsPageState();
}

class _SubmissionsPageState extends State<SubmissionsPage> {
  late Future<List<SubmissionRead>> _submissions;

  Future<List<SubmissionRead>> _fetchSubmissions() async {
    final appSettings = context.read<AppSettings>();
    final secureStorage = context.read<SecureStorage>();

    final submissions = await FetchUtils.get(
      '${appSettings.serverUrl}/submissions/'
      '?challenge_name=${widget._challengeName}',
      headers: {'Authorization': 'Bearer ${secureStorage.loginToken}'},
      failMessage: 'Failed to load submissions for this challenge',
    );

    return (jsonDecode(submissions) as List)
        .map<SubmissionRead>(
          (submission) => SubmissionRead.fromJson(submission),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();

    _submissions = _fetchSubmissions();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Submissions for: ${widget._challengeName}',
      child: FutureBuilder(
        future: _submissions,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return const Text('Loading submissions for this challenge...');
          }

          return _SubmissionsView(submissions: snapshot.data!);
        },
      ),
    );
  }
}

class _SubmissionsView extends StatelessWidget {
  const _SubmissionsView({required List<SubmissionRead> submissions})
      : _submissions = submissions;

  final List<SubmissionRead> _submissions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _submissions
          .map(
            (submission) => Card(
              child: Column(children: [
                UserButton(
                  user: submission.user,
                  onPressed: () {},
                ),
                Text(submission.code),
              ]),
            ),
          )
          .toList(),
    );
  }
}
