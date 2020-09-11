import 'package:meta/meta.dart';

abstract class MoviesListBodyState {}

class Success implements MoviesListBodyState {
  Success({@required this.moviesList, @required this.favoritesList})
      : assert(moviesList != null),
        assert(favoritesList != null);

  final List moviesList;
  final List<int> favoritesList;
}

class Loading implements MoviesListBodyState {}

class Error implements MoviesListBodyState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}
