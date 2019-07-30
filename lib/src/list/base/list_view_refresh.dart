import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef RefreshListCallback = void Function();

class ListViewRefresh extends StatefulWidget {
  final ListView child;
  final RefreshListCallback onRefresh;

  const ListViewRefresh({
    Key key,
    @required this.child,
    this.onRefresh,
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
    );
  }

  Future<void> _refresh() {
    widget.onRefresh?.call();
    return _refreshCompleter.future;
  }
}
