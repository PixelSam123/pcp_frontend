import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:pcp_frontend/types.dart';

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
      message: 'Group: ${_user.group}\n'
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

class PageLayout extends StatelessWidget {
  const PageLayout({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  void _openHomePage(BuildContext context) {
    context.go('/');
  }

  void _openProfilePage(BuildContext context) {
    context.go('/profile');
  }

  void _openSettingsPage(BuildContext context) {
    context.go('/settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: 'home',
                  child: Text('Home'),
                ),
                PopupMenuItem(
                  value: 'profile',
                  child: Text('Profile'),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: Text('Settings'),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case 'home':
                  _openHomePage(context);
                  break;
                case 'profile':
                  _openProfilePage(context);
                  break;
                case 'settings':
                  _openSettingsPage(context);
                  break;
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PadSize.sm),
          child: SizedBox(
            width: double.infinity,
            child: child,
          ),
        ),
      ),
    );
  }
}
