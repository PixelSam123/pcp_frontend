import 'package:flutter/material.dart';
import 'package:pcp_frontend/types/user.dart';

class UserButton extends StatelessWidget {
  const UserButton({
    super.key,
    required UserReadBrief user,
    required VoidCallback onPressed,
  })  : _user = user,
        _onPressed = onPressed;

  final UserReadBrief _user;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Group: ${_user.group?.name ?? 'None'}\n'
          'Points: ${_user.points}',
      child: TextButton(
        onPressed: _onPressed,
        child: Text(
          _user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
