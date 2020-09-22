import 'package:meta/meta.dart';

import 'package:domain/model/model.dart';
import 'package:tokenlab_challenge/presentation/common/generic_error.dart';

abstract class MovieDetailsBodyState {}

class Success implements MovieDetailsBodyState {
  Success({@required this.movieDetails}) : assert(movieDetails != null);

  final MovieLongDetails movieDetails;
}

class Loading implements MovieDetailsBodyState {}

class Error implements MovieDetailsBodyState, GenericError {
  Error({@required this.type}) : assert(type != null);

  @override
  final GenericErrorType type;
}
