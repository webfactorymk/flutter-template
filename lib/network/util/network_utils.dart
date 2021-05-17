import 'package:connectivity/connectivity.dart';

/// Singleton.
/// NetworkUtils class.
/// To obtain instance use NetworkUtils.getInstance()
class NetworkUtils {
  static final NetworkUtils _instance = NetworkUtils._internal();
  late Connectivity _connectivity;

  NetworkUtils._internal() {
    _connectivity = Connectivity();
  }

  static NetworkUtils getInstance() => _instance;

  Future<bool> isConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

//TODO: Add listener for network status changes if needed
//TODO: with _connectivity.onConnectivityChanged.listen()
}
