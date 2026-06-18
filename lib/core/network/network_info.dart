import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstraction for checking device network connectivity.
///
/// Usage:
/// ```dart
/// final isConnected = await NetworkInfo.instance.isConnected;
/// ```
class NetworkInfo {
  NetworkInfo._();
  static final NetworkInfo instance = NetworkInfo._();

  final Connectivity _connectivity = Connectivity();

  /// Returns true if the device has an active network connection.
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty &&
        !result.contains(ConnectivityResult.none);
  }

  /// Stream that emits connectivity changes.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
