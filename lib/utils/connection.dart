import 'package:connectivity/connectivity.dart';

/// Devuelve si hay conexión a Intenet.
Future<bool> check() async {

  var connectivityResult = await (Connectivity().checkConnectivity());

  /// Si esta conectado por wifi o movil devuelve `true`.
  if (connectivityResult == ConnectivityResult.mobile)
    return true;
  else if (connectivityResult == ConnectivityResult.wifi)
    return true;
  /// Si no devuelve `false`.
  return false;
}