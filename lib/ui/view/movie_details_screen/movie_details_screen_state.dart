import 'package:meta/meta.dart';

abstract class MovieDetailsBodyState {}

class Success implements MovieDetailsBodyState {
  Success({@required this.movieDetails, @required this.isFavorite})
      : assert(movieDetails != null),
        assert(isFavorite != null);

  final dynamic movieDetails;
  final bool isFavorite;
}

class Loading implements MovieDetailsBodyState {}

class Error implements MovieDetailsBodyState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}
