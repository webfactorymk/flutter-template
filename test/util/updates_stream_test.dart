import 'package:flutter_template/util/updates_stream.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for updates stream mixin.
void main() {
  late NumberComponent numberComponent;

  setUp(() {
    numberComponent = NumberComponent();
  });

  test('updates no value set', () {
    expect(numberComponent.updates, emitsInOrder([1, 2, 3]));

    numberComponent
      ..increment()
      ..increment()
      ..increment();
  });

  test('updatesSticky no value set', () {
    expect(numberComponent.updatesSticky, emitsInOrder([1, 2, 3]));

    numberComponent
      ..increment()
      ..increment()
      ..increment();
  });

  test('updates after value set', () {
    numberComponent.decrement();

    expect(numberComponent.updates, emitsInOrder([0, 1, 0]));

    numberComponent
      ..increment()
      ..increment()
      ..decrement();
  });

  test('updatesSticky after value set', () {
    numberComponent.decrement();

    expect(numberComponent.updatesSticky, emitsInOrder([-1, 0, 1, 0]));

    numberComponent
      ..increment()
      ..increment()
      ..decrement();
  });

  test('updates null', () {
    expect(numberComponent.updates, emitsInOrder([isNull]));

    numberComponent.setNumber(null);
  });

  test('no updates', () {
    expect(numberComponent.updatesSticky, emitsInOrder([]));

    numberComponent.updatesSticky.listen((_) {});
  });

  test('updates closed when done', () async {
    expect(numberComponent.updates, emitsInOrder([1, 2, 3, emitsDone]));

    numberComponent
      ..increment()
      ..increment()
      ..increment();
    await numberComponent.close();
  });

  test('updatesSticky closed when done', () async {
    expect(numberComponent.updatesSticky, emitsInOrder([1, 2, 3, emitsDone]));

    numberComponent
      ..increment()
      ..increment()
      ..increment();
    await numberComponent.close();
  });
}

class NumberComponent with UpdatesStream<int> {
  int? number;

  void setNumber(int? newNumber) {
    number = newNumber;
    addUpdate(number);
  }

  void increment() {
    presetNumber();
    number = number! + 1;
    addUpdate(number);
  }

  void decrement() {
    presetNumber();
    number = number! - 1;
    addUpdate(number);
  }

  void presetNumber() {
    if (number == null) {
      number = 0;
    }
  }

  Future<void> close() => closeUpdatesStream();
}
