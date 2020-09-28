import 'package:meta/meta.dart';

import 'package:domain/data_repository/movie_data_repository.dart';
import 'package:domain/logger.dart';
import 'package:domain/use_case/use_case.dart';

class UnfavoriteMovieUC extends UseCase<void, UnfavoriteMovieUCParams> {
  UnfavoriteMovieUC({@required this.repository, @required ErrorLogger logger})
      : assert(repository != null),
        assert(logger != null),
        super(logger: logger);

  final MoviesDataRepository repository;

  @override
  Future<void> getRawFuture({UnfavoriteMovieUCParams params}) =>
      repository.unfavoriteMovie(params.movieId);
}

class UnfavoriteMovieUCParams {
  const UnfavoriteMovieUCParams(this.movieId);

  final int movieId;
}
