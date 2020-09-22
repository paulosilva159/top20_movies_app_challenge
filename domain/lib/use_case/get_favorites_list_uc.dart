import 'package:meta/meta.dart';

import 'package:domain/data_repository/movie_data_repository.dart';
import 'package:domain/logger.dart';
import 'package:domain/model/model.dart';
import 'package:domain/use_case/use_case.dart';

class GetFavoritesListUC extends UseCase<List<MovieShortDetails>, void> {
  GetFavoritesListUC({@required this.repository, @required ErrorLogger logger})
      : assert(repository != null),
        assert(logger != null),
        super(logger: logger);

  final MovieDataRepository repository;

  @override
  Future<List<MovieShortDetails>> getRawFuture({void params}) =>
      repository.getFavoritesList();
}
