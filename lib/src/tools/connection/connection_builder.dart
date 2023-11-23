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
/// [online] - a builder for the the [Connection.online] state,
/// [offline] - a builder for the [Connection.offline] state.
class ConnectionBuilder extends BlocBuilder<ConnectionBloc, Connection> {
  ConnectionBuilder({
    super.key,
    super.bloc,
    @Deprecated('This builder will be removed. Use "online" instead.')
    WidgetBuilder? onOnline,
    WidgetBuilder? online,
    @Deprecated('This builder will be removed. Use "offline" instead.')
    WidgetBuilder? onOffline,
    WidgetBuilder? offline,
  })  : assert(
          !(onOnline != null && online != null),
          'The onOnline and online builders should NOT be used together. The onOnline builder is deprecated and can be safely removed.',
        ),
        assert(
          !(onOffline != null && offline != null),
          'The onOffline and offline builders should NOT be used together. The onOffline builder is deprecated and can be safely removed.',
        ),
        super(
          builder: (BuildContext context, Connection state) {
            const none = SizedBox.shrink();
            return switch (state) {
              Connection.online =>
                (online?.call(context) ?? onOnline?.call(context)) ?? none,
              Connection.offline =>
                (offline?.call(context) ?? onOffline?.call(context)) ?? none,
            };
          },
        );
}
