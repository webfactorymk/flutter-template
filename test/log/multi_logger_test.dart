import 'package:flutter_template/log/abstract_logger.dart';
import 'package:flutter_template/log/multi_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

const logMessage = 'log at me when i\'m talking to you';

class MockLogger extends Mock implements AbstractLogger {}

/// Tests for [MultiLogger].
void main() {
  late MockLogger mockLogger1;
  late MockLogger mockLogger2;
  late MultiLogger logger;

  setUp(() {
    mockLogger1 = MockLogger();
    mockLogger2 = MockLogger();

    var loggers = [mockLogger1, mockLogger2];
    logger = MultiLogger(loggers);
  });

  test('log debug, warn and error', () {
    //setup
    final Exception error = Exception('Test exp');

    //execute
    logger.d(logMessage);
    logger.w(logMessage);
    logger.e(error);

    //expect and verify
    verify(mockLogger1.d(logMessage)).called(1);
    verify(mockLogger1.w(logMessage)).called(1);
    verify(mockLogger1.e(error)).called(1);
    verifyNoMoreInteractions(mockLogger1);

    verify(mockLogger2.d(logMessage)).called(1);
    verify(mockLogger2.w(logMessage)).called(1);
    verify(mockLogger2.e(error)).called(1);
    verifyNoMoreInteractions(mockLogger2);
  });
}
