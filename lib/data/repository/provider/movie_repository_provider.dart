import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:tokenlab_challenge/data/cache/data_source/movies_cache_data_source.dart';
import 'package:tokenlab_challenge/data/remote/data_source/movies_remote_data_source.dart';
import 'package:tokenlab_challenge/data/repository/movies_repository.dart';

SingleChildWidget movieRepositoryProvider = ProxyProvider2<
    MoviesRemoteDataSource, MoviesCacheDataSource, MoviesRepository>(
  update: (context, moviesRemoteDataSource, moviesCacheDataSource,
          moviesRepository) =>
      MoviesRepository(
          remoteDataSource: moviesRemoteDataSource,
          cacheDataSource: moviesCacheDataSource),
);
