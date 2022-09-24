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
/// It also takes [WidgetBuilder] functions for available states:
///
/// [onOnline] callback for the the [Connection.online] state,
/// [onOffline] callback for the [Connection.offline] state.
class ConnectionListener extends BlocListener<ConnectionBloc, Connection> {
  ConnectionListener({
    Key? key,
    ConnectionBloc? bloc,
    Widget? child,
    ConnectionCallback? onOnline,
    ConnectionCallback? onOffline,
  }) : super(
          key: key,
          bloc: bloc,
          listenWhen: (Connection previous, Connection current) =>
              previous != current,
          listener: (BuildContext context, Connection state) {
            switch (state) {
              case Connection.online:
                return onOnline?.call(context);
              case Connection.offline:
                return onOffline?.call(context);
            }
          },
          child: child,
        );
}