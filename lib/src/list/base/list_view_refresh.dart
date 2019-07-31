import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A refresh callback.
typedef RefreshListCallback = void Function();

/// A widget that wraps a [ListView] with a [RefreshIndicator] designed to
/// be used with BLoC pattern.
///
/// When swipe to refresh gesture is detected a [onRefresh] callback is
/// executed. The indicator remains visible until the widget is rebuilt.
class ListViewRefresh extends StatefulWidget {
  final ListView child;
  final RefreshListCallback onRefresh;
  final double displacement;
  final Color color;
  final Color backgroundColor;
  final ScrollNotificationPredicate notificationPredicate;
  final String semanticsLabel;
  final String semanticsValue;

  const ListViewRefresh({
    Key key,
    @required this.child,
    @required this.onRefresh,
    this.backgroundColor,
    this.color,
    this.displacement,
    this.notificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
  })  : assert(child != null),
        super(key: key);

  @override
  _ListViewRefreshState createState() => _ListViewRefreshState();
}

class _ListViewRefreshState extends State<ListViewRefresh> {
  Completer<void> _refreshCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    _refreshCompleter?.complete();
    _refreshCompleter = Completer();

    return RefreshIndicator(
      child: widget.child,
      onRefresh: _refresh,
      backgroundColor: widget.backgroundColor,
      color: widget.color,
      displacement: widget.displacement,
      notificationPredicate: widget.notificationPredicate,
      semanticsLabel: widget.semanticsLabel,
      semanticsValue: widget.semanticsValue,
    );
  }

  Future<void> _refresh() {
    widget.onRefresh?.call();
    return _refreshCompleter.future;
  }
}
