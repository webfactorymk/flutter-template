import 'package:flutter_template/log/abstract_logger.dart';
import 'package:flutter_template/log/filtered_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

const logMessage = 'log at me when i\'m talking to you';

class MockLogger extends Mock implements AbstractLogger {}

/// Tests for [FilteredLogger].
void main() {
  late MockLogger logger;
  late FilteredLogger filteredLogger;

  setUp(() {
    logger = MockLogger();
    filteredLogger = FilteredLogger(logger, (_) => true);
  });

  test('log debug, warn and error', () {
    //setup
    final Exception error = Exception('Test exp');

    //execute
    filteredLogger.d(logMessage);
    filteredLogger.w(logMessage);
    filteredLogger.e(error);

    //expect and verify
    verify(logger.d('$logMessage')).called(1);
    verify(logger.w('$logMessage')).called(1);
    verify(logger.e(error)).called(1);
    verifyNoMoreInteractions(logger);
  });

  test('log null', () {
    // ignore: null_check_always_fails
    expect(() => filteredLogger.e(null!), throwsA(isInstanceOf<Error>()));
  });
}
