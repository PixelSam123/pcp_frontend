import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pcp_frontend/components.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:pcp_frontend/types.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const users = [
    UserReadBrief(name: 'guitarhero', group: 'Cupboard', points: 60),
    UserReadBrief(name: 'De', group: 'Kessoku Band', points: 50),
    UserReadBrief(name: 'Fazu', group: 'Kessoku Band', points: 40),
    UserReadBrief(name: 'No', group: 'Kessoku Band', points: 30),
    UserReadBrief(name: 'Hikari', group: 'Kessoku Band', points: 20),
    UserReadBrief(name: 'Kakinarase', group: 'Kessoku Band', points: 10),
  ];

  final activities = [
    Activity(
      user: users[0],
      targetLink: 'http://localhost:8000/a',
      type: 'comment',
    ),
    Activity(
      user: users[1],
      targetLink: 'http://localhost:8000/b',
      type: 'submit',
    ),
    Activity(
      user: users[2],
      targetLink: 'http://localhost:8000/b',
      type: 'submit',
    ),
  ];

  final challenges = [
    Challenge(
      author: users[0],
      title: 'You, you <color>, <color> is no',
      tier: 1,
      supportedLanguages: ['js'],
    ),
    Challenge(
      author: users[5],
      title: 'Indonesian, Korean, English',
      tier: 2,
      supportedLanguages: ['js'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Pixel Code Platform',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: PadSize.large),
          const Leaderboard(users: users),
          const SizedBox(height: PadSize.large),
          Activities(activities: activities),
          const SizedBox(height: PadSize.large),
          const CredentialsForm(),
          const SizedBox(height: PadSize.large),
          Challenges(challenges: challenges),
          const SizedBox(height: PadSize.large),
        ],
      ),
    );
  }
}

class Leaderboard extends StatelessWidget {
  const Leaderboard({
    super.key,
    required List<UserReadBrief> users,
  }) : _users = users;

  final List<UserReadBrief> _users;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        const SizedBox(height: PadSize.medium),
        Text(
          'Leaderboard',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        DataTable(
          columns: ['Name', 'Group', 'Points']
              .map((columnTitle) => DataColumn(
                    label: Text(
                      columnTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ))
              .toList(),
          rows: _users
              .map((user) => DataRow(
                    cells: [user.name, user.group, user.points]
                        .map((field) => DataCell(Text(field.toString())))
                        .toList(),
                  ))
              .toList(),
        ),
      ]),
    );
  }
}

class Activities extends StatelessWidget {
  const Activities({
    super.key,
    required List<Activity> activities,
  }) : _activities = activities;

  final List<Activity> _activities;

  Widget _buildActivity(Activity activity) {
    return Padding(
      padding: const EdgeInsets.all(PadSize.small),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(PadSize.small),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              UserButton(user: activity.user),
              Text(activity.type == 'comment' ? 'commented on' : 'submitted'),
              TextButton(
                onPressed: () {},
                child: Text(activity.targetLink),
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
            const SizedBox(height: PadSize.medium),
            Text(
              'Activities',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            ..._activities.map(_buildActivity),
          ],
        ),
      ),
    );
  }
}

class CredentialsForm extends StatefulWidget {
  const CredentialsForm({super.key});

  @override
  State<CredentialsForm> createState() => _CredentialsFormState();
}

class _CredentialsFormState extends State<CredentialsForm> {
  final _username = TextEditingController();
  final _password = TextEditingController();

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
          TextField(
            controller: _username,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: PadSize.small),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: PadSize.small),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class Challenges extends StatelessWidget {
  const Challenges({
    super.key,
    required List<Challenge> challenges,
  }) : _challenges = challenges;

  final List<Challenge> _challenges;

  void _openChallengePage(BuildContext context) {
    context.go('/challenges');
  }

  Widget _buildChallenge(BuildContext context, Challenge challenge) {
    return Padding(
      padding: const EdgeInsets.all(PadSize.small),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(PadSize.small),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                challenge.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person),
                      UserButton(user: challenge.author),
                    ],
                  ),
                  const SizedBox(width: PadSize.small),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.change_history),
                      const SizedBox(width: PadSize.small),
                      Text('Tier ${challenge.tier}'),
                    ],
                  ),
                  const SizedBox(width: PadSize.large),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.code),
                      const SizedBox(width: PadSize.small),
                      Text(challenge.supportedLanguages.join(', ')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: PadSize.small),
              OutlinedButton(
                onPressed: () => _openChallengePage(context),
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
            const SizedBox(height: PadSize.medium),
            Text(
              'Challenges',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            ..._challenges.map(
              (challenge) => _buildChallenge(context, challenge),
            ),
          ],
        ),
      ),
    );
  }
}
