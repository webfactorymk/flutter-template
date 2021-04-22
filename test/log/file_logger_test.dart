import 'dart:convert';
import 'dart:io';

import 'package:flutter_template/log/file_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synchronized/synchronized.dart';

const logMessage1 = "log at me when i\'m talking to you";
const logMessage2 = "hey! don't log down";
const logMessage3 = "hey, i need to log something";
const logMessage4 = "right now";
const logMessage5 = "at time, here";

class MockFile extends Mock implements File {
  MockFile() {
    throwOnMissingStub(this);
  }

  @override
  String get path => super.noSuchMethod(
        Invocation.getter(#path),
        returnValue: 'path/file.txt',
      );

  @override
  Future<File> writeAsString(
    String? contents, {
    FileMode? mode = FileMode.write,
    Encoding? encoding = utf8,
    bool? flush = false,
  }) {
    super.noSuchMethod(Invocation.method(
      #writeAsString,
      [contents],
      {
        #mode: mode,
        #encoding: encoding,
        #flush: flush,
      },
    ));
    return Future.delayed(Duration(seconds: 2), () => this);
  }
}

/// Tests for [FileLogger].
void main() {
  late Lock fileLock;
  late MockFile file;
  late FileLogger logger;

  /// Setup called before every test
  setUp(() {
    fileLock = Lock();
    file = MockFile();
    logger = FileLogger(fileLock, () => Future.value(file));

    when(file.path).thenReturn('path/file.txt');
    when(file.writeAsString(
      argThat(isNotNull),
      mode: anyNamed('mode'),
      encoding: utf8,
      flush: true,
    )).thenAnswer((realInvocation) async {
      print('┌ write file start:');
      print(realInvocation.positionalArguments[0]);
      print('└ write file end');
      return file;
    });
  });

  test('mock file - log debug, warn, and error', () async {
    // EXECUTE
    print('Log message 1');
    logger.d(logMessage1);

    await Future.delayed(Duration(milliseconds: 200));

    Future.wait([
      Future(() {
        print('Log message 2');
        logger.w(logMessage2);
      }),
      Future(() {
        print('Log message 3');
        logger.e(logMessage3);
      }),
      Future(() {
        print('Log message 4');
        logger.e(logMessage4);
      }),
    ]);

    await Future.delayed(Duration(milliseconds: 4500));

    print('Log message 5');
    logger.e(logMessage5);

    do {
      await Future.delayed(Duration(milliseconds: 600));
    } while (fileLock.locked);

    // VERIFY

    // Log file opening line
    verify(file.writeAsString(
      argThat(contains('LOGGING STARTED')),
      mode: FileMode.write,
      flush: true,
    )).called(1);

    // Log message 1
    verify(file.writeAsString(
      argThat(contains(logMessage1)),
      mode: FileMode.append,
      flush: true,
    )).called(1);

    // Log messages 2, 3, 4 buffered and squashed in one write
    verify(file.writeAsString(
      argThat(allOf(
        contains(logMessage2),
        contains(logMessage3),
        contains(logMessage4),
      )),
      mode: FileMode.append,
      flush: true,
    )).called(1);

    // Log message 5
    verify(file.writeAsString(
      argThat(contains(logMessage5)),
      mode: FileMode.append,
      flush: true,
    )).called(1);

    verifyNoMoreInteractions(file);
  });
}
