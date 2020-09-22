import 'package:domain/exceptions.dart';

enum GenericErrorType { unexpected, noConnection }

abstract class GenericError {
  final GenericErrorType type = GenericErrorType.unexpected;
}

GenericErrorType mapToGenericErrorType(dynamic error) =>
    error is NoConnectionException
        ? GenericErrorType.noConnection
        : GenericErrorType.unexpected;
