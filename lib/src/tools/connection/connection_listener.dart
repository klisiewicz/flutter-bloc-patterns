import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection_bloc.dart';

/// Callback function for [Connection] state changes.
typedef ConnectionCallback = void Function(BuildContext context);

/// [ConnectionListener] is responsible for performing a one-time action based
/// on the [Connection] state change.
///
/// It should be used for functionality that needs to occur only once
/// in response to the [Connection] state change such as navigation,
/// showing a [SnackBar], showing a [Dialog], etc.
///
/// [ConnectionListener] is a wrapper over the [BlocListener] widget so it
/// accepts a [bloc] object as well as a [child] widget.
///
/// It also takes [ConnectionCallback] functions for possible states:
///
/// [onOnline] - a callback for the the [Connection.online] state,
/// [onOffline] - a callback for the [Connection.offline] state.
class ConnectionListener extends BlocListener<ConnectionBloc, Connection> {
  ConnectionListener({
    super.key,
    super.bloc,
    super.child,
    ConnectionCallback? onOnline,
    ConnectionCallback? onOffline,
  }) : super(
          listenWhen: (Connection previous, Connection current) =>
              previous != current,
          listener: (BuildContext context, Connection state) {
            return switch (state) {
              Connection.online => onOnline?.call(context),
              Connection.offline => onOffline?.call(context),
            };
          },
        );
}
