import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  final displayText = find.byValueKey('displayText');
  final buttonInvokeMethod = find.byValueKey('invokeMethod');

  late FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    driver.close();
  });

  test('Invoke Button', () async {
    await driver.tap(buttonInvokeMethod);
    expect(driver.getText(displayText), contains('Battery level'));
  });
}
