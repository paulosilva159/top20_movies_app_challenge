import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:tokenlab_challenge/data/cache/data_source/movies_cache_data_source.dart';
import 'package:tokenlab_challenge/data/remote/data_source/movies_remote_data_source.dart';
import 'package:tokenlab_challenge/data/repository/movies_repository.dart';

List<SingleChildWidget> movieDataProvider = [
  ..._movieRemoteProvider,
  _movieCacheProvider,
  _movieRepositoryProvider,
];

SingleChildWidget _movieRepositoryProvider = ProxyProvider2<
    MoviesRemoteDataSource, MoviesCacheDataSource, MoviesRepository>(
  update: (context, moviesRemoteDataSource, moviesCacheDataSource,
          moviesRepository) =>
      MoviesRepository(
          remoteDataSource: moviesRemoteDataSource,
          cacheDataSource: moviesCacheDataSource),
);

List<SingleChildWidget> _movieRemoteProvider = [
  Provider(
    create: (context) => Dio(),
  ),
  ProxyProvider<Dio, MoviesRemoteDataSource>(
    update: (context, dio, moviesRemoteDataSource) =>
        MoviesRemoteDataSource(dio: dio),
  ),
];

SingleChildWidget _movieCacheProvider = Provider(
  create: (context) => MoviesCacheDataSource(),
);
