import 'package:meta/meta.dart';

import '../../../data/model/model.dart';

abstract class MoviesListBodyState {}

class Success implements MoviesListBodyState {
  Success({@required this.movieList}) : assert(movieList != null);

  final List<MovieShortDetailsRM> movieList;
}

class Loading implements MoviesListBodyState {}

class Error implements MoviesListBodyState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}
