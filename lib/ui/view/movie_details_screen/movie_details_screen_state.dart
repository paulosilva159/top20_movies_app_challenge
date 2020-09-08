import 'package:meta/meta.dart';

import '../../../data/model/model.dart';

abstract class MovieDetailsBodyState {}

class Success implements MovieDetailsBodyState {
  Success({@required this.movieDetails}) : assert(movieDetails != null);

  final MovieLongDetailsRM movieDetails;
}

class Loading implements MovieDetailsBodyState {}

class Error implements MovieDetailsBodyState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}
