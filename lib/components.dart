import 'package:flutter/material.dart';
import 'package:pcp_frontend/types.dart';

class UserButton extends StatelessWidget {
  const UserButton({
    super.key,
    required UserReadBrief user,
  }) : _user = user;

  final UserReadBrief _user;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Group: ${_user.group}\n'
          'Points: ${_user.points}',
      child: TextButton(
        onPressed: () {},
        child: Text(
          _user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
