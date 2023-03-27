import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/ocean.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:pcp_frontend/components.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:pcp_frontend/types.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings with ChangeNotifier {
  AppSettings._create({
    required SharedPreferences prefs,
    required bool isDarkMode,
    required String serverUrl,
  })  : _prefs = prefs,
        _isDarkMode = isDarkMode,
        _serverUrl = serverUrl;

  final SharedPreferences _prefs;
  bool _isDarkMode;
  String _serverUrl;

  static Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();

    return AppSettings._create(
      prefs: prefs,
      isDarkMode: prefs.getBool('isDarkMode') ?? true,
      serverUrl: prefs.getString('serverUrl') ?? 'http://localhost:8000',
    );
  }

  bool get isDarkMode => _isDarkMode;
  set isDarkMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    notifyListeners();
    _prefs.setBool('isDarkMode', _isDarkMode);
  }

  String get serverUrl => _serverUrl;
  set serverUrl(String serverUrl) {
    _serverUrl = serverUrl;
    notifyListeners();
    _prefs.setString('serverUrl', _serverUrl);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final title = 'Pixel Code Platform';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppSettings.load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        return ChangeNotifierProvider(
          create: (context) => snapshot.data!,
          child: Consumer<AppSettings>(
            builder: (context, appSettings, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                ),
                title: title,
                theme: ThemeData(
                  brightness: appSettings.isDarkMode
                      ? Brightness.dark
                      : Brightness.light,
                  primarySwatch: Colors.teal,
                ),
                home: child,
              );
            },
            child: HomePage(title: title),
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title}) : _title = title;

  final String _title;

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

  void _openProfilePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void _openSettingsPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
            ];
          }, onSelected: (value) {
            switch (value) {
              case 'profile':
                _openProfilePage(context);
                break;
              case 'settings':
                _openSettingsPage(context);
                break;
            }
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: PadSize.large),
              OutlinedButton(
                onPressed: () => _openProfilePage(context),
                child: const Text('Open Profile page'),
              ),
              const SizedBox(height: PadSize.large),
              OutlinedButton(
                onPressed: () => _openSettingsPage(context),
                child: const Text('Open Settings page'),
              ),
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
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Column(children: const [
        Text('hi profile page'),
      ]),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _serverUrl = TextEditingController();

  void _setIsDarkMode(AppSettings appSettings, bool value) {
    appSettings.isDarkMode = value;
  }

  void _setServerUrl(AppSettings appSettings, String value) {
    appSettings.serverUrl = value;
  }

  @override
  void initState() {
    super.initState();

    _serverUrl.text = context.read<AppSettings>().serverUrl;
  }

  @override
  void dispose() {
    _serverUrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer<AppSettings>(
        builder: (context, appSettings, child) {
          return Column(children: [
            Row(children: [
              const Text('Dark mode'),
              Switch(
                value: appSettings.isDarkMode,
                onChanged: (value) => _setIsDarkMode(appSettings, value),
              ),
            ]),
            TextField(
              controller: _serverUrl,
              onChanged: (value) => _setServerUrl(appSettings, value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Server URL',
              ),
            ),
          ]);
        },
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
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChallengePage(),
                  ),
                ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Challenge #1')),
      body: Column(children: [
        const Text('Challenge page\nPretend this is a nice description'),
        CodeTheme(
          data: CodeThemeData(styles: oceanTheme),
          child: SingleChildScrollView(
            child: CodeField(
              controller: controller,
              textStyle: const TextStyle(
                fontFamily: 'monospace',
                fontFamilyFallback: ['Consolas'],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
