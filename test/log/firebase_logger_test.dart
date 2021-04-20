import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_template/log/firebase_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_logger_test.mocks.dart';

const logMessage = 'log at me when i\'m talking to you';

/// Tests for [FirebaseLogger].
@GenerateMocks([FirebaseCrashlytics])
void main() {
  late MockFirebaseCrashlytics crashlytics;
  late FirebaseLogger firebaseLogger;

  /// Setup called before every test
  setUp(() {
    crashlytics = MockFirebaseCrashlytics();
    firebaseLogger = FirebaseLogger(crashlytics);

    // Stub a mock methods before interacting
    // Put general behavior here. For more specific behavior
    // put the stubs in the test methods.
    when(crashlytics.log(any)).thenAnswer((invocation) => Future.value());
  });

  // Called after every test
  tearDown(() {
    // no need to cleanup resources for the [FirebaseLogger]
  });

  test('log debug, warn, and error', () {
    //setup
    final Exception error = Exception('Test exp');

    //execute
    firebaseLogger.d(logMessage);
    firebaseLogger.w(logMessage);
    firebaseLogger.e(error);

    //expect and verify
    verify(crashlytics.log('(D) $logMessage')).called(1);
    verify(crashlytics.log('(W) $logMessage')).called(1);
    verify(crashlytics.log('(E) Exception: Test exp')).called(1);
    verifyNoMoreInteractions(crashlytics);
  });

  test('log null', () {
    // ignore: null_check_always_fails
    expect(() => firebaseLogger.e(null!), throwsA(isInstanceOf<Error>()));
  });
}
