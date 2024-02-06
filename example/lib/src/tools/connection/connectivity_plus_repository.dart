import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc_patterns/connection.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityPlusRepository implements ConnectionRepository {
  final Connectivity _connectivity;

  ConnectivityPlusRepository(Connectivity connectivity)
      : _connectivity = connectivity;

  @override
  Stream<Connection> observe() {
    // Required due to https://github.com/fluttercommunity/plus_plugins/issues/2527
    return MergeStream([
      Stream.fromFuture(_connectivity.checkConnectivity()),
      _connectivity.onConnectivityChanged,
    ]).map(
      (ConnectivityResult result) => result != ConnectivityResult.none
          ? Connection.online
          : Connection.offline,
    );
  }
}
