import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection_builder.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection_listener.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection_repository.dart';

/// A BLoC that exposes Internet connection state to the UI.
///
/// [ConnectionBloc] automatically starts observing connection changes
/// provided by [ConnectionRepository] so no action is required.
///
/// Designed to collaborate with [ConnectionBuilder] to render UI based on the
/// [Connection] state and with [ConnectionListener] to perform one-time action
/// when the connection state changes (navigation, displaying a [SnackBar] or
/// a dialog).
///
/// By default it's initialized in the [Connection.online] state and emits
/// distinct values whenever [Connection] state changes.
class ConnectionBloc extends Cubit<Connection> {
  final ConnectionRepository _connectionRepository;
  late final StreamSubscription<Connection> _subscription;

  ConnectionBloc(ConnectionRepository connectionRepository)
      : _connectionRepository = connectionRepository,
        super(Connection.online) {
    _subscription = _connectionRepository.observe().distinct().listen(emit);
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
