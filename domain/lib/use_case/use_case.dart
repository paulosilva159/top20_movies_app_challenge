import 'dart:async';

import 'package:meta/meta.dart';

import '../exceptions.dart';
import '../logger.dart';

abstract class UseCase<R, P> {
  UseCase({@required this.logger}) : assert(logger != null);

  final ErrorLogger logger;

  @protected
  Future<R> getRawFuture({P params});

  Future<R> getFuture({P params}) => getRawFuture(params: params).catchError(
        (error) {
          logger(error);

          throw error;
        },
      ).catchError(
        (error) {
          if (error is MoviesException) {
            throw UnexpectedException();
          } else {
            throw Error();
          }
        },
      );
}
