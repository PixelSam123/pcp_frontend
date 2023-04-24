import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:pcp_frontend/pages/login.dart';
import 'package:pcp_frontend/secure_storage.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/pages/challenge.dart';
import 'package:pcp_frontend/pages/challenge_create.dart';
import 'package:pcp_frontend/pages/home.dart';
import 'package:pcp_frontend/pages/profile.dart';
import 'package:pcp_frontend/pages/settings.dart';
import 'package:pcp_frontend/pages/submissions.dart';
import 'package:provider/provider.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

final _router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => HomePage(key: state.pageKey),
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => ProfilePage(key: state.pageKey),
  ),
  GoRoute(
    path: '/settings',
    builder: (context, state) => SettingsPage(key: state.pageKey),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => LoginPage(key: state.pageKey),
  ),
  GoRoute(
    path: '/challenge_create',
    builder: (context, state) => ChallengeCreatePage(key: state.pageKey),
  ),
  GoRoute(
    path: '/challenge/:challengeName',
    builder: (context, state) => ChallengePage(
      key: state.pageKey,
      challengeName: state.params['challengeName']!,
    ),
  ),
  GoRoute(
    path: '/submissions/:challengeName',
    builder: (context, state) => SubmissionsPage(
      key: state.pageKey,
      challengeName: state.params['challengeName']!,
    ),
  ),
]);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appSettings = Future.wait([
    AppSettings.load(),
    SecureStorage.load(),
  ]);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _appSettings,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: Text('Loading app settings...')),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => snapshot.data![0] as AppSettings,
            ),
            ChangeNotifierProvider(
              create: (context) => snapshot.data![1] as SecureStorage,
            ),
          ],
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor:
                      context.select((AppSettings s) => s.textScale),
                ),
                child: child!,
              ),
              theme: ThemeData(
                brightness: context.select((AppSettings s) => s.isDarkMode)
                    ? Brightness.dark
                    : Brightness.light,
                primarySwatch: Colors.teal,
              ),
              routerConfig: _router,
            );
          },
        );
      },
    );
  }
}
