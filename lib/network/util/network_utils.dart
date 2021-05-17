import 'dart:async';

import 'package:connectivity/connectivity.dart';

/// Network connectivity utils.
///
/// To obtain instance use serviceLocator.get<NetworkUtils>()
class NetworkUtils {
  final Connectivity _connectivity;

  NetworkUtils(this._connectivity);

  Stream<ConnectivityResult> get connectionUpdates =>
      _connectivity.onConnectivityChanged;

  Future<ConnectivityResult> getConnectivityResult() =>
      _connectivity.checkConnectivity();

  /// There is no guarantee that the user has network connection
  /// it only returns true if the device is connected with wi-fi or mobile data
  Future<bool> isConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
