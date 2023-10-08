import 'package:flutter/material.dart';
import 'package:flutter_playground/pages/bottom_navbar.dart';
import 'package:flutter_playground/pages/home.dart';
import 'package:flutter_playground/pages/my_home.dart';
import 'package:flutter_playground/pages/test_page/detail_screen.dart';
import 'package:flutter_playground/pages/test_page/root_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppRoute {
  home,
  myHome,
  b,
}

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorEventsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellEvents');
final _shellNavigatorAccountKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellAccount');

final routeProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: '/',
      navigatorKey: _rootNavigatorKey,
      routes: [
        ShellRoute(
          builder: (context, state, child) => Scaffold(
            resizeToAvoidBottomInset: false,
            body: child,
            // backgroundColor: Colors.amber,
          ),
          routes: [
            GoRoute(
              name: AppRoute.home.name,
              path: '/',
              pageBuilder: (context, state) =>
                  NoTransitionPage(key: state.pageKey, child: const Home()),
              redirect: (context, state) => null,
              routes: [
                GoRoute(
                  name: AppRoute.myHome.name,
                  path: 'myHome',
                  pageBuilder: (context, state) => NoTransitionPage(
                      key: state.pageKey,
                      child: const MyHomePage(title: 'Flutter Demo Home Page')),
                ),
              ],
            ),
          ],
        ),
        StatefulShellRoute.indexedStack(
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state, navigationShell) =>
              BottomNavbar(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRoute.b.name,
                  path: '/b',
                  pageBuilder: (context, state) => const NoTransitionPage(
                      child: RootScreen(
                    label: 'B',
                    detailsPath: '/b/details',
                  )),
                  redirect: (context, state) => null,
                  routes: [
                    GoRoute(
                      path: 'details',
                      builder: (context, state) => const DetailsScreen(
                        label: 'B',
                      ),
                    )
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/protected/c',
                  pageBuilder: (context, state) => const NoTransitionPage(
                      child: RootScreen(
                    label: 'C',
                    detailsPath: '/protected/c/details',
                  )),
                  redirect: (context, state) => null,
                  routes: [
                    GoRoute(
                      path: 'details',
                      builder: (context, state) => const DetailsScreen(
                        label: 'C',
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  },
);
