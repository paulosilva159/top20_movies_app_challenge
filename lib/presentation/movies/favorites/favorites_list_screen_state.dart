import 'package:meta/meta.dart';

import 'package:domain/model/model.dart';

abstract class FavoritesListScreenState {}

class Success implements FavoritesListScreenState {
  Success({
    @required this.favorites,
  }) : assert(favorites != null);

  final List<MovieShortDetails> favorites;
}

class Loading implements FavoritesListScreenState {}

class Error implements FavoritesListScreenState {
  Error({
    @required this.error,
  }) : assert(error != null);

  final dynamic error;
}
