import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc_patterns/connection.dart';

class ConnectivityPlusRepository implements ConnectionRepository {
  final Connectivity _connectivity;

  ConnectivityPlusRepository(Connectivity connectivity)
      : _connectivity = connectivity;

  @override
  Stream<Connection> observe() {
    return _connectivity.onConnectivityChanged.map(
      (ConnectivityResult result) => result != ConnectivityResult.none
          ? Connection.online
          : Connection.offline,
    );
  }
}
