import 'package:meta/meta.dart';

import 'package:domain/data_repository/movie_data_repository.dart';
import 'package:domain/logger.dart';
import 'package:domain/model/model.dart';
import 'package:domain/use_case/use_case.dart';

class GetMovieUC extends UseCase<MovieLongDetails, GetMovieDetailsUCParams> {
  GetMovieUC({@required this.repository, @required ErrorLogger logger})
      : assert(repository != null),
        assert(logger != null),
        super(logger: logger);

  final MovieDataRepository repository;

  @override
  Future<MovieLongDetails> getRawFuture(
          {@required GetMovieDetailsUCParams params}) =>
      repository.getMovieDetails(params.movieId);
}

class GetMovieDetailsUCParams {
  const GetMovieDetailsUCParams(this.movieId);

  final int movieId;
}
