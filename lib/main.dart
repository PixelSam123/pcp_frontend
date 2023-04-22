import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:pcp_frontend/settings.dart';
import 'package:pcp_frontend/pages/challenge.dart';
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
    path: '/challenges',
    builder: (context, state) => ChallengePage(key: state.pageKey),
  ),
  GoRoute(
    path: '/submissions',
    builder: (context, state) => SubmissionsPage(key: state.pageKey),
  ),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppSettings.load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        return ChangeNotifierProvider(
          create: (context) => snapshot.data!,
          child: Consumer<AppSettings>(
            builder: (context, appSettings, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: appSettings.textScale,
                  ),
                  child: child!,
                ),
                theme: ThemeData(
                  brightness: appSettings.isDarkMode
                      ? Brightness.dark
                      : Brightness.light,
                  primarySwatch: Colors.teal,
                ),
                routerConfig: _router,
              );
            },
          ),
        );
      },
    );
  }
}
