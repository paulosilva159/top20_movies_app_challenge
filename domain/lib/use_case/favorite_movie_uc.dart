import 'package:meta/meta.dart';

import 'package:domain/data_repository/movie_data_repository.dart';
import 'package:domain/logger.dart';
import 'package:domain/use_case/use_case.dart';

class FavoriteMovieUC extends UseCase<void, FavoriteMovieUCParams> {
  FavoriteMovieUC({@required this.repository, @required ErrorLogger logger})
      : assert(repository != null),
        assert(logger != null),
        super(logger: logger);

  final MoviesDataRepository repository;

  @override
  Future<void> getRawFuture({FavoriteMovieUCParams params}) =>
      repository.favoriteMovie(params.movieId);
}

class FavoriteMovieUCParams {
  const FavoriteMovieUCParams(this.movieId);

  final int movieId;
}
