import 'package:dio/dio.dart';
import 'package:domain/data_observables.dart';
import 'package:domain/data_repository/movie_data_repository.dart';
import 'package:domain/use_case/favorite_movie_uc.dart';
import 'package:domain/use_case/get_favorites_list_uc.dart';
import 'package:domain/use_case/get_movie_details_uc.dart';
import 'package:domain/use_case/get_movies_list_uc.dart';
import 'package:domain/use_case/unfavorite_movie_uc.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tokenlab_challenge/common/utils.dart';
import 'package:tokenlab_challenge/data/cache/data_source/movies_cache_data_source.dart';
import 'package:tokenlab_challenge/data/remote/data_source/movies_remote_data_source.dart';
import 'package:tokenlab_challenge/data/remote/infrastucture/movies_dio.dart';
import 'package:tokenlab_challenge/data/remote/infrastucture/url_builder.dart';
import 'package:tokenlab_challenge/data/repository/movies_repository.dart';
import 'package:tokenlab_challenge/presentation/common/movies_structure_type.dart';
import 'package:tokenlab_challenge/presentation/common/routes.dart';
import 'package:tokenlab_challenge/presentation/main_content_screen.dart';
import 'package:tokenlab_challenge/presentation/movies/details/movie_details_screen.dart';
import 'package:tokenlab_challenge/presentation/movies/favorites/favorites_list_screen.dart';
import 'package:tokenlab_challenge/presentation/movies/list/movies_list_screen.dart';

class TMGlobalProvider extends StatefulWidget {
  const TMGlobalProvider({@required this.builder}) : assert(builder != null);

  final WidgetBuilder builder;

  @override
  _TMGlobalProviderState createState() => _TMGlobalProviderState();
}

class _TMGlobalProviderState extends State<TMGlobalProvider> {
  final _activeFavoriteUpdate = PublishSubject<void>();

  final SingleChildWidget _movieRepositoryProvider = ProxyProvider2<
      MoviesRemoteDataSource, MoviesCacheDataSource, MoviesDataRepository>(
    update: (context, moviesRemoteDataSource, moviesCacheDataSource, _) =>
        MoviesRepository(
            remoteDataSource: moviesRemoteDataSource,
            cacheDataSource: moviesCacheDataSource),
  );

  final List<SingleChildWidget> _movieRemoteProviders = [
    Provider<Dio>(
      create: (context) => MoviesDio(
        BaseOptions(
          baseUrl: PathBuilder.moviesList(),
        ),
      ),
    ),
    ProxyProvider<Dio, MoviesRemoteDataSource>(
      update: (context, dio, _) => MoviesRemoteDataSource(dio: dio),
    ),
  ];

  final SingleChildWidget _movieCacheProvider = Provider(
    create: (context) => MoviesCacheDataSource(),
  );

  final List<SingleChildWidget> _useCaseProviders = [
    ProxyProvider2<MoviesDataRepository, Log, GetMoviesListUC>(
      update: (context, repository, log, _) =>
          GetMoviesListUC(repository: repository, logger: log.errorLogger),
    ),
    ProxyProvider2<MoviesDataRepository, Log, GetMovieDetailsUC>(
      update: (context, repository, log, _) =>
          GetMovieDetailsUC(repository: repository, logger: log.errorLogger),
    ),
    ProxyProvider2<MoviesDataRepository, Log, GetFavoritesListUC>(
      update: (context, repository, log, _) =>
          GetFavoritesListUC(repository: repository, logger: log.errorLogger),
    ),
    ProxyProvider3<MoviesDataRepository, Log, ActiveFavoriteUpdateSinkWrapper,
        FavoriteMovieUC>(
      update: (context, repository, log, activeFavoriteUpdateSinkWrapper, _) =>
          FavoriteMovieUC(
              repository: repository,
              logger: log.errorLogger,
              activeFavoriteUpdateSinkWrapper: activeFavoriteUpdateSinkWrapper),
    ),
    ProxyProvider3<MoviesDataRepository, Log, ActiveFavoriteUpdateSinkWrapper,
        UnfavoriteMovieUC>(
      update: (context, repository, log, activeFavoriteUpdateSinkWrapper, _) =>
          UnfavoriteMovieUC(
              repository: repository,
              logger: log.errorLogger,
              activeFavoriteUpdateSinkWrapper: activeFavoriteUpdateSinkWrapper),
    ),
  ];

  List<SingleChildWidget> _dataObservablesProvider() => [
        Provider<ActiveFavoriteUpdateStreamWrapper>(
          create: (_) =>
              ActiveFavoriteUpdateStreamWrapper(_activeFavoriteUpdate.stream),
        ),
        Provider<ActiveFavoriteUpdateSinkWrapper>(
          create: (_) =>
              ActiveFavoriteUpdateSinkWrapper(_activeFavoriteUpdate.sink),
        ),
      ];

  List<SingleChildWidget> _fluroProviders() => [
        Provider<FluroRouter>(
          create: (_) => FluroRouter()
            ..define(
              Routes.home,
              handler: Handler(
                handlerFunc: (context, params) => MoviesInitialScreen(),
              ),
            )
            ..define(
              Routes.favorites,
              handler: Handler(
                  handlerFunc: (context, params) =>
                      FavoritesListScreen.create()),
            )
            ..define(
              Routes.moviesList,
              handler: Handler(
                handlerFunc: (context, params) {
                  final movieStructureType =
                      params[Routes.moviesListQueryParam][0];

                  return MoviesListScreen.create(EnumToString.fromString(
                      MovieStructureType.values, movieStructureType));
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
            ),
        ),
        ProxyProvider<FluroRouter, RouteFactory>(
          update: (context, router, _) => (settings) => router
              .matchRoute(context, settings.name, routeSettings: settings)
              .route,
        ),
      ];

  final SingleChildWidget _logProvider = Provider<Log>(
    create: (context) => Log(),
  );

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._fluroProviders(),
          ..._dataObservablesProvider(),
          _movieCacheProvider,
          ..._movieRemoteProviders,
          _movieRepositoryProvider,
          _logProvider,
          ..._useCaseProviders
        ],
        child: widget.builder(context),
      );

  @override
  void dispose() {
    _activeFavoriteUpdate.close();
    super.dispose();
  }
}
