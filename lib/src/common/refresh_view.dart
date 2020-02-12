import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A widget that wraps a [widget] with a [RefreshIndicator] designed to
/// be used with BLoC pattern.
///
/// When swipe to refresh gesture is detected a [onRefresh] callback is
/// executed. The indicator remains visible until the widget is rebuilt.
class RefreshView extends StatefulWidget {
  final Widget child;
  final VoidCallback onRefresh;
  final double displacement;
  final Color color;
  final Color backgroundColor;
  final ScrollNotificationPredicate notificationPredicate;
  final String semanticsLabel;
  final String semanticsValue;

  const RefreshView({
    Key key,
    @required this.child,
    this.onRefresh,
    this.backgroundColor,
    this.color,
    this.displacement = 40.0,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
  })  : assert(child != null),
        assert(displacement != null),
        assert(notificationPredicate != null),
        super(key: key);

  @override
  _RefreshViewState createState() => _RefreshViewState();
}

class _RefreshViewState extends State<RefreshView> {
  Completer<void> _refreshCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    _refreshCompleter?.complete();
    _refreshCompleter = Completer();

    return RefreshIndicator(
      backgroundColor: widget.backgroundColor,
      color: widget.color,
      displacement: widget.displacement,
      notificationPredicate: widget.notificationPredicate,
      semanticsLabel: widget.semanticsLabel,
      semanticsValue: widget.semanticsValue,
      onRefresh: _refresh,
      child: widget.child,
    );
  }

  Future<void> _refresh() {
    widget.onRefresh?.call();
    return _refreshCompleter.future;
  }
}
