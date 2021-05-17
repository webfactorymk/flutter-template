import 'dart:async';

import 'package:connectivity/connectivity.dart';

typedef Future<void> _ConnectivityStatusListener(ConnectivityResult result);

/// NetworkUtils class.
///
/// To obtain instance use serviceLocator.get<NetworkUtils>()
class NetworkUtils {
  late Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  NetworkUtils(Connectivity connectivity) {
    _connectivity = connectivity;
  }

  Future<bool> isConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void addConnectivityListener(
      _ConnectivityStatusListener connectivityStatusListener) {
    if (_connectivitySubscription != null) removeConnectivityListener();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(connectivityStatusListener);
  }

  void removeConnectivityListener() {
    _connectivitySubscription!.cancel();
    _connectivitySubscription = null;
  }
}
