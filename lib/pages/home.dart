import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pcp_frontend/components.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:pcp_frontend/types/challenge.dart';
import 'package:pcp_frontend/types/user.dart';
import 'package:pcp_frontend/utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<UserReadBrief>> _users;
  late Future<List<ChallengeReadBrief>> _challenges;

  Future<List<UserReadBrief>> _fetchUsers() async {
    final appSettings = context.read<AppSettings>();

    final users = await FetchUtils.get(
      '${appSettings.serverUrl}/users',
      failMessage: 'Failed to load users',
    );

    return (jsonDecode(users) as List)
        .map<UserReadBrief>((user) => UserReadBrief.fromJson(user))
        .toList();
  }

  Future<List<ChallengeReadBrief>> _fetchChallenges() async {
    final appSettings = context.read<AppSettings>();

    final challenges = await FetchUtils.get(
      '${appSettings.serverUrl}/challenges',
      failMessage: 'Failed to load challenges',
    );

    return (jsonDecode(challenges) as List)
        .map<ChallengeReadBrief>(
          (challenge) => ChallengeReadBrief.fromJson(challenge),
        )
        .toList();
  }

  void _refreshServerData() {
    setState(() {
      _users = _fetchUsers();
      _challenges = _fetchChallenges();
    });
  }

  @override
  void initState() {
    super.initState();

    _refreshServerData();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Pixel Code Platform',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: PadSize.md),
          OutlinedButton(
            onPressed: _refreshServerData,
            child: const Text('Refresh server data'),
          ),
          const SizedBox(height: PadSize.lg),
          FutureBuilder(
            future: _users,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return const Text('Loading users...');
              }

              return _Leaderboard(users: snapshot.data!);
            },
          ),
          const SizedBox(height: PadSize.lg),
          FutureBuilder(
            future: _challenges,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return const Text('Loading challenges...');
              }

              return _Challenges(challenges: snapshot.data!);
            },
          ),
          const SizedBox(height: PadSize.lg),
        ],
      ),
    );
  }
}

class _Leaderboard extends StatelessWidget {
  const _Leaderboard({required List<UserReadBrief> users}) : _users = users;

  final List<UserReadBrief> _users;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        const SizedBox(height: PadSize.md),
        Text(
          'Leaderboard',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        DataTable(
          columns: ['Name', 'Group', 'Points']
              .map(
                (columnTitle) => DataColumn(
                  label: Text(
                    columnTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
              .toList(),
          rows: _users
              .map(
                (user) => DataRow(
                  cells: [user.name, user.group, user.points]
                      .map((field) => DataCell(Text(field.toString())))
                      .toList(),
                ),
              )
              .toList(),
        ),
      ]),
    );
  }
}

class _Challenges extends StatelessWidget {
  const _Challenges({required List<ChallengeReadBrief> challenges})
      : _challenges = challenges;

  final List<ChallengeReadBrief> _challenges;

  void _openChallengePage(BuildContext context, String challengeName) {
    context.go('/challenge/$challengeName');
  }

  void _openChallengeCreatePage(BuildContext context) {
    context.go('/challenge_create');
  }

  Widget _buildChallenge(BuildContext context, ChallengeReadBrief challenge) {
    return Padding(
      padding: const EdgeInsets.all(PadSize.sm),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(PadSize.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                challenge.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person),
                      UserButton(
                        user: challenge.user,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(width: PadSize.sm),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.change_history),
                      const SizedBox(width: PadSize.sm),
                      Text('Tier ${challenge.tier}'),
                    ],
                  ),
                  const SizedBox(width: PadSize.lg),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.code),
                      SizedBox(width: PadSize.sm),
                      Text('js'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: PadSize.sm),
              OutlinedButton(
                onPressed: () => _openChallengePage(context, challenge.name),
                child: const Text('View'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: PadSize.md),
            Text(
              'Challenges',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PadSize.md),
            OutlinedButton(
              onPressed: () => _openChallengeCreatePage(context),
              child: const Text('Create your own'),
            ),
            ..._challenges
                .map((challenge) => _buildChallenge(context, challenge)),
          ],
        ),
      ),
    );
  }
}
