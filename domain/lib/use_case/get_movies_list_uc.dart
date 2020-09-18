import 'package:meta/meta.dart';

import '../data_repository/movie_data_repository.dart';
import '../logger.dart';
import '../model/model.dart';
import '../use_case/use_case.dart';

class GetMoviesListUC extends UseCase<List<MovieShortDetails>, void> {
  GetMoviesListUC({@required this.repository, @required ErrorLogger logger})
      : assert(repository != null),
        assert(logger != null),
        super(logger: logger);

  final MovieDataRepository repository;

  @override
  Future<List<MovieShortDetails>> getRawFuture({void params}) =>
      repository.getMoviesList();
}
