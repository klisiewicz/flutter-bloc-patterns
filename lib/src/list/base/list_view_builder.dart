import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_states.dart';

typedef LoadingCallback = Widget Function(BuildContext context);
typedef RefreshCallback<T> = Widget Function(
    BuildContext context,
    List<T> items,
    );
typedef ResultCallback<T> = Widget Function(
  BuildContext context,
  List<T> items,
);
typedef NoResultCallback = Widget Function(BuildContext context);
typedef ErrorCallback = Widget Function(
  BuildContext context,
  Exception exception,
);

class ListViewBuilder<T> {
  final LoadingCallback onLoading;
  final RefreshCallback<T> onRefreshing;
  final ResultCallback<T> onResult;
  final NoResultCallback onNoResult;
  final ErrorCallback onError;

  ListViewBuilder({
    this.onLoading,
    this.onRefreshing,
    this.onResult,
    this.onNoResult,
    this.onError,
  });

  Widget build(BuildContext context, ListState state) {
    if (state is ListLoading)
      return onLoading?.call(context) ?? Container();
    else if (state is ListRefreshing)
      return onRefreshing != null
          ? onRefreshing.call(context, state.items)
          : onResult?.call(context, state.items) ?? Container();
    else if (state is ListNotLoaded)
      return onError?.call(context, state.exception) ?? Container();
    else if (state is ListLoaded<T>)
      return onResult?.call(context, state.items) ?? Container();
    else
      return onNoResult?.call(context) ?? Container();
  }
}
