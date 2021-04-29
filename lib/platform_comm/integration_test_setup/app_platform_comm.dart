import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';

class AppPlatformComm extends StatefulWidget {
  @override
  _AppPlatformCommState createState() => _AppPlatformCommState();
}

class _AppPlatformCommState extends State<AppPlatformComm> {
  String _batteryLevel = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PlatformComm Integration test'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(key: Key('displayText'), child: Text(_batteryLevel)),
            ElevatedButton(key: Key('invokeMethod'),onPressed: _getBatteryInformation, child: Text('invokeMethod')),
            ElevatedButton(onPressed: (){}, child: Text('invokeProcedure')),
            ElevatedButton(onPressed: (){}, child: Text('listenMethod')),
            ElevatedButton(onPressed: _resetBatteryInfo, child: Text('reset'))
          ],
        ),

      ),
    );
  }

  final batteryChannel = PlatformComm(MethodChannel('battery'));

  Future<void> _getBatteryInformation() async {
    String batteryLevel = '';
    try {
      int result = await batteryChannel.invokeMethod<int, String>(
          method: 'getBatteryInfo', param: null);
      batteryLevel = 'Battery level is at $result %';
    } on PlatformException catch (e) {
      batteryLevel = 'Failed to get battery information: ${e.message}';
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  void _resetBatteryInfo() {
    setState(() {
      _batteryLevel = '';
    });
  }
}
