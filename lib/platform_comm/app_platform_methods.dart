import 'dart:convert';

import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';
import 'package:flutter_template/util/subscription.dart';

const String nativeLogs = 'nativeLogs';
const String platformTestMethod = 'platformTestMethod';
const String platformTestMethod2 = 'platformTestMethod2';

/// Platform methods specific for this app.
extension AppPlatformMethods on PlatformComm {
  /// Listens for custom log messages from the platform side.
  Subscription listenToNativeLogs() => this.listenMethod<String>(
      method: nativeLogs, callback: (logMessage) => Log.d(logMessage));

  /// For testing only.
  Future<String> echoMessage(String echoMessage) =>
      this.invokeMethod(method: platformTestMethod, param: echoMessage);

  /// For testing only.
  Future<TaskGroup> echoObject(TaskGroup echoObject) =>
      this.invokeMethod<TaskGroup, TaskGroup>(
        method: platformTestMethod2,
        param: echoObject,
        serializeParam: (object) => jsonEncode(object.toJson()),
        deserializeResult: (data) => TaskGroup.fromJson(jsonDecode(data)),
      );
}
