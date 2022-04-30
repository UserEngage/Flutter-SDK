import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  late ConnectivityResult _currentConnection;

  late StreamSubscription _connectionStream;

  static ConnectionService get instance => _getOrCreateInstance();
  static ConnectionService? _instance;

  static ConnectionService _getOrCreateInstance() {
    if (_instance != null) return _instance!;
    _instance = ConnectionService();

    return _instance!;
  }

  Future<void> initialize() async {
    final connectivity = Connectivity();
    _currentConnection = await connectivity.checkConnectivity();
    _connectionStream = connectivity.onConnectivityChanged.listen(
      (event) {
        _currentConnection = event;
      },
    );
  }

  ConnectivityResult get connectionState => _currentConnection;

  bool get isConnected =>
      _currentConnection == ConnectivityResult.mobile ||
      _currentConnection == ConnectivityResult.mobile;

  void dispose() => _connectionStream.cancel();
}
