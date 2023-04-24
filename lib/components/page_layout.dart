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

  void _goBack(BuildContext context) {
    context.pop();
  }

  void _openHomePage(BuildContext context) {
    context.push('/');
  }

  void _openProfilePage(BuildContext context) {
    context.push('/profile/${context.read<SecureStorage>().userName}');
  }

  void _openSettingsPage(BuildContext context) {
    context.push('/settings');
  }

  void _openLoginPage(BuildContext context) {
    context.push('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _goBack(context),
              )
            : null,
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
