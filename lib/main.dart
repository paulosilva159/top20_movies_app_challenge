import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tokenlab_challenge/ui/view/movie_details_screen/movie_details_screen.dart';

import 'generated/l10n.dart';

import 'ui/view/movies_home_screen/movies_home_screen.dart';

void main() {
  Router.appRouter
    ..define(
      '/',
      handler: Handler(
        handlerFunc: (context, params) => MoviesHomeScreen(),
      ),
    )
    ..define(
      '/movies',
      handler: Handler(
        handlerFunc: (context, params) => Container(),
      ),
    )
    ..define(
      '/movies/:id',
      handler: Handler(
        handlerFunc: (context, params) {
          final id = int.parse(params['id'][0]);

          return MovieDetailsScreen(
            id: id,
          );
        },
      ),
    );

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
        onGenerateRoute: (settings) => Router.appRouter
            .matchRoute(context, settings.name, routeSettings: settings)
            .route,
      );
}
