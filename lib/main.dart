import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'ui/view/movies_home_screen/movies_home_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        home: MoviesHomeScreen(),
      );
}
