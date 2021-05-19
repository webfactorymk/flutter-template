import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:flutter_template/util/Either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Success', () {
    late Task expectedTask;

    setUp(() {
      expectedTask =
          Task(id: '1', status: TaskStatus.done, title: 'Expected title');
    });

    test('Either.success', () async {
      // act
      final Either<Exception, Task> actualEither = Either.success(expectedTask);

      // assert
      expect(actualEither, isA<Success>());
      expect(actualEither, isNot(isA<Error>()));
      expect((actualEither as Success).value, expectedTask);
    });

    test('Either.build, success', () async {
      // act
      final Either<Exception, Task> actualEither =
          Either.build(() => expectedTask);

      // assert
      expect(actualEither, isA<Success>());
      expect(actualEither, isNot(isA<Error>()));
      expect((actualEither as Success).value, expectedTask);
    });
  });

  group('Error', () {
    late Exception expectedException;

    setUp(() {
      expectedException = Exception('Throw me');
    });

    test('Either.error', () async {
      // act
      final Either<Exception, Task> actualEither =
          Either.error(expectedException);

      // assert
      expect(actualEither, isA<Error>());
      expect(actualEither, isNot(isA<Success>()));
      expect((actualEither as Error).error, expectedException);
    });

    test('Either.build, error', () async {
      // act
      final Either<Exception, Task> actualEither =
          Either.build(() => throw expectedException);

      // assert
      expect(actualEither, isA<Error>());
      expect(actualEither, isNot(isA<Success>()));
      expect((actualEither as Error).error, expectedException);
    });
  });
}
