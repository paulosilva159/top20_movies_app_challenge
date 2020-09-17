import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'data/model/model.dart';

import 'generated/l10n.dart';

import 'routes/routes.dart';

import 'ui/components/movies_structure_type.dart';

import 'ui/view/favorites_screen/favorites_list_screen.dart';
import 'ui/view/movie_details_screen/movie_details_screen.dart';
import 'ui/view/movies_initial_screen.dart';
import 'ui/view/movies_list_screen/movies_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive
    ..init((await getApplicationDocumentsDirectory()).path)
    ..registerAdapter<MovieLongDetailsCM>(MovieLongDetailsCMAdapter())
    ..registerAdapter<MovieShortDetailsCM>(MovieShortDetailsCMAdapter());

  Router.appRouter
    ..define(
      Routes.home,
      handler: Handler(
        handlerFunc: (context, params) => MoviesInitialScreen(),
      ),
    )
    ..define(
      Routes.favorites,
      handler: Handler(handlerFunc: (context, params) => FavoritesListScreen()),
    )
    ..define(
      Routes.moviesList,
      handler: Handler(
        handlerFunc: (context, params) {
          final movieStructureType = params[Routes.moviesListQueryParam][0];

          return MoviesListScreen(
              movieStructureType: movieStructureType ==
                      EnumToString.convertToString(MovieStructureType.list)
                  ? MovieStructureType.list
                  : MovieStructureType.grid);
        },
      ),
    )
    ..define(
      '${Routes.movieDetails}/:${Routes.movieDetailsIdParam}',
      handler: Handler(
        handlerFunc: (context, params) {
          final id = int.parse(params[Routes.movieDetailsIdParam][0]);

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
