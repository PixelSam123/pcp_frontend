import 'package:flutter/material.dart';
import 'package:pcp_frontend/types.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final title = 'Pixel Code Platform';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final users = const [
    UserReadBrief(name: "guitarhero", group: "Cupboard", points: 60),
    UserReadBrief(name: "De", group: "Kessoku Band", points: 50),
    UserReadBrief(name: "Fazu", group: "Kessoku Band", points: 40),
    UserReadBrief(name: "No", group: "Kessoku Band", points: 30),
    UserReadBrief(name: "Hikari", group: "Kessoku Band", points: 20),
    UserReadBrief(name: "Kakinarase", group: "Kessoku Band", points: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Leaderboard(users: users),
              const Activities(),
              const CredentialsForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key, required this.users});

  final List<UserReadBrief> users;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const SizedBox(height: 12.0),
          Text(
            "Leaderboard",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          DataTable(
            columns: ["Name", "Group", "Points"]
                .map((columnTitle) => DataColumn(
                      label: Text(
                        columnTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ))
                .toList(),
            rows: users
                .map((user) => DataRow(
                      cells: [user.name, user.group, user.points]
                          .map((field) => DataCell(Text(field.toString())))
                          .toList(),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class Activities extends StatelessWidget {
  const Activities({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const SizedBox(height: 12.0),
          Text(
            "Activities",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
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
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    username.dispose();
    password.dispose();

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
            controller: username,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              labelText: 'Username',
            ),
          ),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              labelText: 'Password',
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
