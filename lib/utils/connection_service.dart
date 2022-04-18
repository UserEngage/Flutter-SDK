import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  late ConnectivityResult _currentConnection;

  late StreamSubscription _connectionStream;

  static Future<ConnectionService> get instance async =>
      await _getOrCreateInstance();
  static ConnectionService? _instance;

  static Future<ConnectionService> _getOrCreateInstance() async {
    if (_instance != null) return _instance!;
    _instance = ConnectionService();
    await _instance!.initialize();
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

  void dispose() => _connectionStream.cancel();
}
