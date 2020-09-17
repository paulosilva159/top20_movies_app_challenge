import 'dart:async';

import 'package:meta/meta.dart';

import '../data_repository/movie_data_repository.dart';
import '../logger.dart';
import 'use_case.dart';

class UnfavoriteMovieUC extends UseCase<void, UnfavoriteMovieUCParams> {
  UnfavoriteMovieUC({
    @required this.repository,
    @required ErrorLogger logger,
  })  : assert(repository != null),
        assert(logger != null),
        super(logger: logger);

  final MovieDataRepository repository;

  @override
  Future<void> getRawFuture({UnfavoriteMovieUCParams params}) =>
      repository.unfavoriteMovie(params.movieId);
}

class UnfavoriteMovieUCParams {
  const UnfavoriteMovieUCParams(this.movieId);

  final int movieId;
}
