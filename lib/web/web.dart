import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:peony/peony.dart';
import 'package:peony/utils/use_model.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../route/router.dart';
import '../utils/theme.dart';

class MyWeb extends StatelessWidget {
  const MyWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Jinli\'s Blog',
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: context.watch<UseModel>().themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      locale: const Locale('en'),
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
