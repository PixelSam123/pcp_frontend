import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:pcp_frontend/types/user.dart';

class UserButton extends StatelessWidget {
  const UserButton({
    super.key,
    required UserReadBrief user,
  }) : _user = user;

  final UserReadBrief _user;

  void _openProfilePage(BuildContext context) {
    context.push('/profile/${_user.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Group: ${_user.group?.name ?? 'None'}\n'
          'Points: ${_user.points}',
      child: TextButton(
        onPressed: () => _openProfilePage(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person),
            const SizedBox(width: PadSize.sm),
            Text(
              _user.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
