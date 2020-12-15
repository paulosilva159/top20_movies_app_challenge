import 'package:domain/data_observables.dart';
import 'package:domain/data_repository/movie_data_repository.dart';
import 'package:domain/logger.dart';
import 'package:domain/use_case/use_case.dart';
import 'package:meta/meta.dart';

class FavoriteMovieUC extends UseCase<void, FavoriteMovieUCParams> {
  FavoriteMovieUC(
      {@required this.repository,
      @required ErrorLogger logger,
      @required this.activeFavoriteUpdateSinkWrapper})
      : assert(repository != null),
        assert(activeFavoriteUpdateSinkWrapper != null),
        assert(logger != null),
        super(logger: logger);

  final MoviesDataRepository repository;
  final ActiveFavoriteUpdateSinkWrapper activeFavoriteUpdateSinkWrapper;

  @override
  Future<void> getRawFuture({FavoriteMovieUCParams params}) => repository
      .favoriteMovie(params.movieId)
      .then((_) => activeFavoriteUpdateSinkWrapper.value.add(null));
}

class FavoriteMovieUCParams {
  const FavoriteMovieUCParams(this.movieId);

  final int movieId;
}
