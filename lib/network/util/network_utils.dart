import 'package:connectivity/connectivity.dart';

/// NetworkUtils class.
///
/// To obtain instance use serviceLocator.get<NetworkUtils>()
class NetworkUtils {
  late Connectivity _connectivity;

  NetworkUtils(Connectivity connectivity) {
    _connectivity = connectivity;
  }

  Future<bool> isConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

//TODO: Add listener for network status changes if needed
//TODO: with _connectivity.onConnectivityChanged.listen()
}
