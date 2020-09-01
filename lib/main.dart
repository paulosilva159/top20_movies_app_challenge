import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tokenlab_challenge/routes/routes.dart';

import 'generated/l10n.dart';

import 'ui/components/movies_structure.dart';
import 'ui/view/movie_details_screen/movie_details_screen.dart';
import 'ui/view/movies_home_screen/movies_home_screen.dart';
import 'ui/view/movies_list_screen/movies_list_screen.dart';

void main() {
  Router.appRouter
    ..define(
      Routes.initial,
      handler: Handler(
        handlerFunc: (context, params) => MoviesHomeScreen(),
      ),
    )
    ..define(
      '/${Routes.favorites}',
      handler: Handler(
        handlerFunc: (context, params) => Container(
          child: const Center(
            child: Text('Favs'),
          ),
        ),
      ),
    )
    ..define(
      '/${Routes.moviesView}',
      handler: Handler(
        handlerFunc: (context, params) {
          final movieStructureType = params['movieStructureType'][0];

          return MoviesListScreen(
            movieStructureType: movieStructureType == 'list'
                ? MovieStructureType.list
                : MovieStructureType.grid,
          );
        },
      ),
    )
    ..define(
      '/${Routes.movieDetails}',
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
