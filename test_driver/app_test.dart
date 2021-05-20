import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('PlatformComm', () {
    final textEchoMessage = find.byValueKey('echoMessage');
    final textEchoTaskGroup = find.byValueKey('echoTaskGroup');

    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.close();
    });

    test('Invoke method echo', () async {
      await driver.waitFor(textEchoMessage);
      expect(await driver.getText(textEchoMessage), equals('echo'));

      await driver.waitFor(textEchoTaskGroup);
      expect(await driver.getText(textEchoTaskGroup),
          equals('TaskGroup{id: TG-id, name: Test group, taskIds: [1, 2]}'));
    });
  });
}
