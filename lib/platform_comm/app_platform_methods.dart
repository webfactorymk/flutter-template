import 'package:flutter_template/log/logger.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';

const String nativeLogs = 'nativeLogs';
const String platformTestMethod = "platformTestMethod";

/// Platform methods specific for this app.
extension AppPlatformMethods on PlatformComm {

  /// Listens for custom log messages from the platform side.
  PlatformComm listenToNativeLogs() {
    this.listenMethod<String>(
        method: nativeLogs, callback: (logMessage) => Logger.d(logMessage));
    return this;
  }

  /// For testing only.
  Future<String> echoMessage(String echoMessage) =>
      this.invokeMethod(method: platformTestMethod, param: echoMessage);
}
