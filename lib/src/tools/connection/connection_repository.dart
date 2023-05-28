import 'package:flutter_bloc_patterns/src/tools/connection/connection.dart';
import 'package:meta/meta.dart';

/// [ConnectionRepository] exposes a [Stream] of [Connection] state changes.
@immutable
abstract interface class ConnectionRepository {
  /// Notifies about connection state changes, such as going online or offline.
  Stream<Connection> observe();
}
