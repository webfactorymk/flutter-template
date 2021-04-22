import 'dart:io';

import 'package:flutter_template/log/file_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synchronized/synchronized.dart';

const logMessage = 'log at me when i\'m talking to you';

class MockFile extends Mock implements File {}

/// Tests for [FileLogger].
void main() {
  late FileLogger fileLogger;
  late MockFile mockFile;

  /// Setup called before every test
  setUp(() async {
    mockFile = MockFile();
    fileLogger = FileLogger.withFile(Lock(), mockFile);
  });

  test('log debug, warn, and error', () {
    //setup
    final Exception error = Exception('Test exp');
  });
}
