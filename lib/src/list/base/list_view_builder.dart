import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_states.dart';

/// Callback function for the loading state.
typedef LoadingCallback = Widget Function(BuildContext context);

/// Callback function for the refresh state. It may contain a list of elements
/// when a successful data fetch has already been completed otherwise the list
/// will be empty.
typedef RefreshCallback<T> = Widget Function(
  BuildContext context,
    List<T> elements,
);

/// Callback function for a success. The data was fetched and none empty
/// list was returned.
typedef ResultCallback<T> = Widget Function(
  BuildContext context,
    List<T> elements,
);

/// Callback function for no result. The data was fetched
/// successfully but an empty list wast returned.
typedef NoResultCallback = Widget Function(BuildContext context);

/// Callback function for an error. It contains an [Exception] that has caused
/// which may allow a view to react differently on different errors.
typedef ErrorCallback = Widget Function(
  BuildContext context,
  Exception exception,
);

/// A builder for creating a [Widget] based on [ListState].
///
/// [onLoading] is called when when list state is [ListLoading]
/// [onRefreshing] is called when when list state is [ListRefreshing]. When
/// callback is not provided [onResult] callback will be executed.
/// [onResult] is called when when list state is [ListLoaded].
/// [onNoResult] is called when when list state is [ListLoadedEmpty].
/// [onError] is called when when list state is [ListNotLoaded].
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

  /// Creates a widget based on provided callbacks and state.
  Widget build(BuildContext context, ListState state) {
    if (state is ListLoading)
      return onLoading?.call(context) ?? Container();
    else if (state is ListRefreshing)
      return onRefreshing != null
          ? onRefreshing.call(context, state.elements)
          : onResult?.call(context, state.elements) ?? Container();
    else if (state is ListNotLoaded)
      return onError?.call(context, state.exception) ?? Container();
    else if (state is ListLoaded<T>)
      return onResult?.call(context, state.elements) ?? Container();
    else
      return onNoResult?.call(context) ?? Container();
  }
}
