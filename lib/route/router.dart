import 'dart:ui';

import 'package:peony/json_parser/parser_json.dart';

import '../pages/layout.dart';
import '../peony.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/',
      builder: (context, state) => ScreenUtilInit(
          designSize: const Size(1920, 1080),
          builder: (_, child) {
            // return const MyHomePage();
            // return const Layout();

            return JsonAnalysisTool();
          }),
    ),
    // GoRoute(
    //   name: 'page2',
    //   path: '/page2',
    //   builder: (context, state) => Page2Screen(),
    // ),
  ],
);
