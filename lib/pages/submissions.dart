import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pcp_frontend/components.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/types.dart';
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
    final response = await http.get(
      Uri.parse(
        '${appSettings.serverUrl}/submissions/'
        '?challenge_name=${widget._challengeName}',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)
          .map<SubmissionRead>(
            (submission) => SubmissionRead.fromJson(submission),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to load submissions for this challenge. '
        '${response.statusCode} ${response.reasonPhrase}',
      );
    }
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
            (submission) => Text(submission.toString()),
          )
          .toList(),
    );
  }
}
