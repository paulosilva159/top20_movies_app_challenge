import 'package:meta/meta.dart';

import 'package:domain/model/model.dart';
import 'package:tokenlab_challenge/presentation/common/generic_error.dart';

abstract class FavoritesListScreenState {}

class Success implements FavoritesListScreenState {
  Success({
    @required this.favorites,
  }) : assert(favorites != null);

  final List<MovieShortDetails> favorites;
}

class Loading implements FavoritesListScreenState {}

class Error implements FavoritesListScreenState, GenericError {
  Error({@required this.type}) : assert(type != null);

  @override
  final GenericErrorType type;
}
