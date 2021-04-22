import 'package:flutter_template/log/abstract_logger.dart';
import 'package:flutter_template/log/filtered_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

const logMessage = 'log at me when i\'m talking to you';

class MockLogger extends Mock implements AbstractLogger {}

/// Tests for [FilteredLogger].
void main() {
  late MockLogger logger;

  setUp(() {
    logger = MockLogger();
  });

  test('log debug, warn and error', () {
    //setup
    final Exception error = Exception('Test exp');
    final FilteredLogger filteredLogger = FilteredLogger(logger, (_) => true);

    //execute
    filteredLogger.d(logMessage);
    filteredLogger.w(logMessage);
    filteredLogger.e(error);

    //expect and verify
    verify(logger.d(logMessage)).called(1);
    verify(logger.w(logMessage)).called(1);
    verify(logger.e(error)).called(1);
    verifyNoMoreInteractions(logger);
  });

  test('log filter all logs', () {
    //setup
    final Exception error = Exception('Test exp');
    final FilteredLogger filteredLogger = FilteredLogger(logger, (_) => false);

    //execute
    filteredLogger.d(logMessage);
    filteredLogger.w(logMessage);
    filteredLogger.e(error);

    //expect and verify
    verifyNever(logger.d(logMessage));
    verifyNever(logger.w(logMessage));
    verifyNever(logger.e(error));
    verifyNoMoreInteractions(logger);
  });
}
