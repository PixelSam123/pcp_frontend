import 'package:flutter/material.dart';

class SubmissionsPage extends StatelessWidget {
  const SubmissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submissions C #1')),
      body: Column(children: const [
        Text('hi i am a line'),
        Text('me too'),
      ]),
    );
  }
}
