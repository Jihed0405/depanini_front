import 'package:connectivity_plus/connectivity_plus.dart';
class NetworkService {

Future<bool> checkInternetConnection() async {
  try {
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    return !connectivityResult.contains(ConnectivityResult.none);
  } catch (_) {
    return false;
  }
}

}

  
