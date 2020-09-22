import 'package:meta/meta.dart';

import 'package:domain/model/model.dart';
import 'package:tokenlab_challenge/presentation/common/generic_error.dart';

abstract class MoviesListBodyState {}

class Success implements MoviesListBodyState {
  Success({
    @required this.moviesList,
  }) : assert(moviesList != null);

  final List<MovieShortDetails> moviesList;
}

class Loading implements MoviesListBodyState {}

class Error implements MoviesListBodyState, GenericError {
  Error({@required this.type}) : assert(type != null);

  @override
  final GenericErrorType type;
}
