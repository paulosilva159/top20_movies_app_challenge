import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'data/cache/data_source/movies_cache_data_source.dart';
import 'data/cache/model/cache_model.dart';
import 'data/remote/data_source/movies_remote_data_source.dart';
import 'data/repository/movies_repository.dart';

import 'generated/l10n.dart';

import 'presentation/common/movies_structure_type.dart';
import 'presentation/common/routes.dart';
import 'presentation/main_content_screen.dart';
import 'presentation/movies/details/movie_details_screen.dart';
import 'presentation/movies/favorites/favorites_list_screen.dart';
import 'presentation/movies/list/movies_list_screen.dart';

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
            movieStructureType ==
                    EnumToString.convertToString(MovieStructureType.list)
                ? MovieStructureType.list
                : MovieStructureType.grid,
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
        providers: [
          Provider(
            create: (_) => Dio(),
          ),
          Provider(
            create: (_) => MoviesCacheDataSource(),
          ),
          ProxyProvider<Dio, MoviesRemoteDataSource>(
            update: (context, dio, moviesRemoteDataSource) =>
                MoviesRemoteDataSource(dio: dio),
          ),
          ProxyProvider2<MoviesRemoteDataSource, MoviesCacheDataSource,
              MoviesRepository>(
            update: (context, moviesRemoteDataSource, moviesCacheDataSource,
                    moviesRepository) =>
                MoviesRepository(
                    remoteDataSource: moviesRemoteDataSource,
                    cacheDataSource: moviesCacheDataSource),
          )
        ],
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
