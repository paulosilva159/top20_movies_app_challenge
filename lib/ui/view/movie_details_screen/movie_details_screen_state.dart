import 'package:meta/meta.dart';

import 'package:tokenlab_challenge/data/model/cache/cache_model.dart';

abstract class MovieDetailsBodyState {}

class Success implements MovieDetailsBodyState {
  Success({@required this.movieDetails, this.isFavorite = false})
      : assert(movieDetails != null);

  final MovieLongDetailsCM movieDetails;
  final bool isFavorite;
}

class Loading implements MovieDetailsBodyState {}

class Error implements MovieDetailsBodyState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}
