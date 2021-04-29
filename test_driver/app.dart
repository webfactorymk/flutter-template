import 'package:flutter/cupertino.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_template/platform_comm/integration_test_setup/app_platform_comm.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(AppPlatformComm());
}
