import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityService {
  Stream<bool> get isOnlineStream;
  Future<bool> get isOnline;
  void dispose();
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityServiceImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _controller.add(_checkIsOnline(results));
    });
  }

  bool _checkIsOnline(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  @override
  Stream<bool> get isOnlineStream => _controller.stream;

  @override
  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return _checkIsOnline(results);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
