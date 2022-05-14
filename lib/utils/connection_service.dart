import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

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

  Future<void> initialize({
    required VoidCallback connectedOnInitialize,
    required VoidCallback onConnectionRestored,
    required VoidCallback disconnectedOnInitialize,
  }) async {
    final connectivity = Connectivity();
    _currentConnection = await connectivity.checkConnectivity();

    if (isConnected) {
      connectedOnInitialize();
    } else {
      disconnectedOnInitialize();
    }

    _connectionStream = connectivity.onConnectivityChanged.listen(
      (event) async {
        if (onConnectedFromNoInternet(event)) {
          _currentConnection = event;
          onConnectionRestored();
        }
        _currentConnection = event;
      },
    );
  }

  ConnectivityResult get connectionState => _currentConnection;

  bool get isConnected =>
      _currentConnection == ConnectivityResult.mobile ||
      _currentConnection == ConnectivityResult.wifi;

  bool onConnectedFromNoInternet(ConnectivityResult newConnection) =>
      (_currentConnection == ConnectivityResult.none ||
          _currentConnection == ConnectivityResult.bluetooth) &&
      (newConnection == ConnectivityResult.mobile ||
          newConnection == ConnectivityResult.wifi);

  void dispose() => _connectionStream.cancel();
}
