import 'package:domain/logger.dart';
import 'package:logger/logger.dart';

class Log {
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  ErrorLogger errorLogger(dynamic error) => (error) {
        final stackTrace = error is Error ? error.stackTrace : null;

        logger.e('UseCase Error', [error, stackTrace]);
      };
}
