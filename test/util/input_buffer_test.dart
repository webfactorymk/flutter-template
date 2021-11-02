import 'package:flutter_template/util/input_buffer.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for [InputBuffer].
void main() {
  late InputBuffer inputBuffer;

  setUp(() {
    inputBuffer = InputBuffer(coolDown: Duration(milliseconds: 99));
  });

  tearDown(() {
    inputBuffer.close();
  });

  test('input buffer basic test', () async {
    expect(
      inputBuffer.consumePeriodicInputChanges(),
      emitsInOrder(['app', 'apple']),
    );

    inputBuffer.reportInputChange('a');
    inputBuffer.reportInputChange('app');
    await Future.delayed(inputBuffer.coolDown);
    inputBuffer.reportInputChange('appl');
    inputBuffer.reportInputChange(null);
    inputBuffer.reportInputChange('apple');
    await Future.delayed(inputBuffer.coolDown);
  });
}
