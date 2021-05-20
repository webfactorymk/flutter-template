import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';
import 'package:test/test.dart';

void main() {
  group('PlatformComm', () {

    late FlutterDriver driver;
    late PlatformComm platformComm;

    setUpAll(() async {
      driver = await FlutterDriver.connect();

    });

    tearDownAll(() async {
      await driver.close();
    });

    setUp(() {
      platformComm = PlatformComm.generalAppChannel();
    });

    tearDown(() {
      platformComm.teardown();
    });

    test('Invoke method echo message', () async {
      final invokeMethodResult = await platformComm.echoMessage('echo');

      expect(invokeMethodResult, equals('echo'));
    });

    test('Invoke method echo object', () async {
      final taskGroup = TaskGroup('TG-id', 'Test group', List.of(['1', '2']));
      final invokeMethodResult = await platformComm.echoObject(taskGroup);

      expect(invokeMethodResult, equals(taskGroup));
    });
  });
}
