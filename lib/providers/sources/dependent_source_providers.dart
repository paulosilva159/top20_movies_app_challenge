import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:tokenlab_challenge/data/movies_repository.dart';
import 'package:tokenlab_challenge/data/sources/sources.dart';

List<SingleChildWidget> dependentSourceProviders = [
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
];
