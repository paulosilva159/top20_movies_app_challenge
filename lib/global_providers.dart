import 'package:dio/dio.dart';
import 'package:domain/use_case/get_favorites_list_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:domain/use_case/favorite_movie_uc.dart';
import 'package:domain/use_case/get_movie_details_uc.dart';
import 'package:domain/use_case/unfavorite_movie_uc.dart';
import 'package:domain/data_repository/movie_data_repository.dart';
import 'package:domain/use_case/get_movies_list_uc.dart';

import 'package:tokenlab_challenge/common/utils.dart';
import 'package:tokenlab_challenge/data/cache/data_source/movies_cache_data_source.dart';
import 'package:tokenlab_challenge/data/remote/data_source/movies_remote_data_source.dart';
import 'package:tokenlab_challenge/data/remote/infrastucture/movies_dio.dart';
import 'package:tokenlab_challenge/data/remote/infrastucture/url_builder.dart';
import 'package:tokenlab_challenge/data/repository/movies_repository.dart';

List<SingleChildWidget> globalProviders = [
  _movieCacheProvider,
  ..._movieRemoteProviders,
  _movieRepositoryProvider,
  _logProvider,
  ..._useCaseProviders
];

SingleChildWidget _movieRepositoryProvider = ProxyProvider2<
    MoviesRemoteDataSource, MoviesCacheDataSource, MoviesDataRepository>(
  update: (context, moviesRemoteDataSource, moviesCacheDataSource, _) =>
      MoviesRepository(
          remoteDataSource: moviesRemoteDataSource,
          cacheDataSource: moviesCacheDataSource),
);

List<SingleChildWidget> _movieRemoteProviders = [
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

SingleChildWidget _movieCacheProvider = Provider(
  create: (context) => MoviesCacheDataSource(),
);

List<SingleChildWidget> _useCaseProviders = [
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
  ProxyProvider2<MoviesDataRepository, Log, FavoriteMovieUC>(
    update: (context, repository, log, _) =>
        FavoriteMovieUC(repository: repository, logger: log.errorLogger),
  ),
  ProxyProvider2<MoviesDataRepository, Log, UnfavoriteMovieUC>(
    update: (context, repository, log, _) =>
        UnfavoriteMovieUC(repository: repository, logger: log.errorLogger),
  ),
];

SingleChildWidget _logProvider = Provider<Log>(
  create: (context) => Log(),
);
