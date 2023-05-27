import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection_bloc.dart';

/// [ConnectionBuilder] is responsible for building the UI based
/// on the [Connection] state.
///
/// It's a wrapper over the [BlocBuilder] widget so it accepts a [bloc] object
/// and provides [WidgetBuilder] functions for possible states:
///
/// [onOnline] - a builder for the the [Connection.online] state,
/// [onOffline] - a builder for the [Connection.offline] state.
class ConnectionBuilder extends BlocBuilder<ConnectionBloc, Connection> {
  ConnectionBuilder({
    super.key,
    super.bloc,
    WidgetBuilder? onOnline,
    WidgetBuilder? onOffline,
  }) : super(
          builder: (BuildContext context, Connection state) {
            switch (state) {
              case Connection.online:
                return onOnline?.call(context) ?? const SizedBox.shrink();
              case Connection.offline:
                return onOffline?.call(context) ?? const SizedBox.shrink();
            }
          },
        );
}
