import 'package:meta/meta.dart';

import 'package:tokenlab_challenge/data/model/model.dart';

abstract class MoviesListBodyState {}

class Success implements MoviesListBodyState {
  Success({@required this.moviesList, @required this.favoritesList})
      : assert(moviesList != null),
        assert(favoritesList != null);

  final List<MovieShortDetailsCM> moviesList;
  final List<int> favoritesList;
}

class Loading implements MoviesListBodyState {}

class Error implements MoviesListBodyState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}
