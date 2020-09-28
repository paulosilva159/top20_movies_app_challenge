import 'package:flutter/material.dart';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:tokenlab_challenge/data/cache/model/movies_cache_model.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';

import 'package:tokenlab_challenge/presentation/common/movies_structure_type.dart';
import 'package:tokenlab_challenge/presentation/common/routes.dart';
import 'package:tokenlab_challenge/presentation/main_content_screen.dart';
import 'package:tokenlab_challenge/presentation/movies/details/movie_details_screen.dart';
import 'package:tokenlab_challenge/presentation/movies/favorites/favorites_list_screen.dart';
import 'package:tokenlab_challenge/presentation/movies/list/movies_list_screen.dart';
import 'package:tokenlab_challenge/global_providers.dart';

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
      handler: Handler(
          handlerFunc: (context, params) => FavoritesListScreen.create()),
    )
    ..define(
      Routes.moviesList,
      handler: Handler(
        handlerFunc: (context, params) {
          final movieStructureType = params[Routes.moviesListQueryParam][0];

          return MoviesListScreen.create(
              EnumToString.
              fromString(MovieStructureType.values, movieStructureType)
          );
        },
      ),
    )
    ..define(
      '${Routes.movieDetails}/:${Routes.movieDetailsIdParam}',
      handler: Handler(
        handlerFunc: (context, params) {
          final id = int.parse(params[Routes.movieDetailsIdParam][0]);

          return MovieDetailsScreen.create(id);
        },
      ),
    );

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: globalProviders,
        child: MaterialApp(
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
        ),
      );
}
