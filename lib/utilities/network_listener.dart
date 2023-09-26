import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart'; //For StreamController/Stream

class ConnectionStatusSingleton {
  ConnectionStatusSingleton._();

  static final _instance = ConnectionStatusSingleton._();
  static ConnectionStatusSingleton get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialize() async {
    await checkConnectionStatus();
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  Future<bool> checkConnectionStatus() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    return await _checkStatus(result);
  }

  Future<bool> _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    final dio = Dio();
    try {
      await dio.get(
        'http://www.google.com',
      );
      isOnline = true;
    }on DioException {
      isOnline = false;
    }

    // try {
    //   final result = await InternetAddress.lookup('google.com');
    //   isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    //   print("result $result");
    // } on SocketException catch (_) {
    //   isOnline = false;
    // }
    _controller.sink.add(isOnline);
    return isOnline;
  }

  void disposeStream() => _controller.close();
}
