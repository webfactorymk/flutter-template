import 'package:flutter_template/log/console_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart' as console;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'console_logger_test.mocks.dart';

const logMessage = 'log at me when i\'m talking to you';

/// Tests for [ConsoleLogger].
@GenerateMocks([console.Logger])
void main() {
  late MockLogger logger;
  late ConsoleLogger consoleLogger;

  setUp(() {
    logger = MockLogger();
    consoleLogger = ConsoleLogger(logger);

    when(logger.log(any, any)).thenAnswer((invocation) => Future.value());
  });

  test('log debug, warn and error', () {
    //setup
    final Exception error = Exception('Test exp');

    //execute
    consoleLogger.d(logMessage);
    consoleLogger.w(logMessage);
    consoleLogger.e(error);

    //expect and verify
    verify(logger.d(logMessage)).called(1);
    verify(logger.w(logMessage)).called(1);
    verify(logger.e('Exception: Test exp', error)).called(1);
    verifyNoMoreInteractions(logger);
  });
}
