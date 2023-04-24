import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pcp_frontend/components/page_layout.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:pcp_frontend/types/user.dart';
import 'package:pcp_frontend/utils.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required String userName,
  }) : _userName = userName;

  final String _userName;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserReadBrief> _userProfile;

  Future<UserReadBrief> _fetchUserProfile() async {
    final appSettings = context.read<AppSettings>();

    final userProfile = await FetchUtils.get(
      '${appSettings.serverUrl}/users/${widget._userName}',
      failMessage: 'Failed to load user',
    );

    return UserReadBrief.fromJson(jsonDecode(userProfile));
  }

  @override
  void initState() {
    super.initState();

    _userProfile = _fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Profile for ${widget._userName}',
      child: FutureBuilder(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return Text('Loading profile for ${widget._userName}...');
          }

          return Column(children: [
            Text(
              snapshot.data!.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: PadSize.md),
            Text('Group: ${snapshot.data!.group ?? 'None'}'),
            const SizedBox(height: PadSize.sm),
            Text('Points: ${snapshot.data!.points}'),
          ]);
        },
      ),
    );
  }
}
