import 'dart:async';

import 'package:meta/meta.dart';

import '../data_repository/movie_data_repository.dart';
import '../logger.dart';

import 'use_case.dart';

class FavoriteMovieUC extends UseCase<void, FavoriteMovieUCParams> {
  FavoriteMovieUC({
    @required this.repository,
    @required ErrorLogger logger,
  })  : assert(repository != null),
        assert(logger != null),
        super(logger: logger);

  final MovieDataRepository repository;

  @override
  Future<void> getRawFuture({FavoriteMovieUCParams params}) =>
      repository.favoriteMovie(params.movieId);
}

class FavoriteMovieUCParams {
  const FavoriteMovieUCParams(this.movieId);

  final int movieId;
}
