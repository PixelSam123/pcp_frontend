import 'package:flutter/material.dart';
import 'package:pcp_frontend/components/page_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Profile',
      child: Column(children: const [
        Text('hi profile page'),
      ]),
    );
  }
}
