import 'dart:async';

import 'package:meta/meta.dart';

import '../data_repository/movie_data_repository.dart';
import '../logger.dart';

import 'use_case.dart';

class GetFavoritesListUC extends UseCase<List<int>, void> {
  GetFavoritesListUC({
    @required this.repository,
    @required ErrorLogger logger,
  })  : assert(repository != null),
        assert(logger != null),
        super(logger: logger);

  final MovieDataRepository repository;

  @override
  Future<List<int>> getRawFuture({void params}) =>
      repository.getFavoritesMoviesId();
}
