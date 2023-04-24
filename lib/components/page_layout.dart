import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pcp_frontend/secure_storage.dart';
import 'package:pcp_frontend/sizes.dart';
import 'package:provider/provider.dart';

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
    context.go('/profile/${context.read<SecureStorage>().userName}');
  }

  void _openSettingsPage(BuildContext context) {
    context.go('/settings');
  }

  void _openLoginPage(BuildContext context) {
    context.go('/login');
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
                PopupMenuItem(
                  value: 'login',
                  child: Text('Login'),
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
                case 'login':
                  _openLoginPage(context);
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
