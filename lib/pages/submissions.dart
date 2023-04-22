import 'package:flutter/material.dart';
import 'package:pcp_frontend/components.dart';

class SubmissionsPage extends StatelessWidget {
  const SubmissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Submissions C #1',
      child: Column(children: const [
        Text('hi i am a line'),
        Text('me too'),
      ]),
    );
  }
}
