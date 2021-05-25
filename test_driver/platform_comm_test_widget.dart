import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';

class PlatformCommTestWidget extends StatefulWidget {
  PlatformCommTestWidget({Key? key}) : super(key: key);

  @override
  _PlatformCommTestWidgetState createState() => _PlatformCommTestWidgetState();
}

class _PlatformCommTestWidgetState extends State<PlatformCommTestWidget> {
  String? echoMessage;
  TaskGroup? echoTaskGroup;

  @override
  void initState() {
    super.initState();
    callPlatformMethods();
  }

  Future<void> callPlatformMethods() async {
    final platformComm = serviceLocator.get<PlatformComm>();
    final message = await platformComm.echoMessage('echo');
    final taskGroup = await platformComm
        .echoObject(TaskGroup('TG-id', 'Test group', List.of(['1', '2'])));

    setState(() {
      echoMessage = message;
      echoTaskGroup = taskGroup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        echoMessage != null
            ? Text(echoMessage!, key: Key('echoMessage'))
            : LinearProgressIndicator(value: null),
        echoTaskGroup != null
            ? Text(echoTaskGroup?.toString() ?? '', key: Key('echoTaskGroup'))
            : LinearProgressIndicator(value: null),
      ],
    );
  }
}
