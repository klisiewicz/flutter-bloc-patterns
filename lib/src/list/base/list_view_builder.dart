import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_states.dart';

/// Callback function for the list loading state.
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
class ListViewBuilder<T> {
  final LoadingCallback _onLoading;
  final RefreshCallback<T> _onRefreshing;
  final ResultCallback<T> _onResult;
  final NoResultCallback _onNoResult;
  final ErrorCallback _onError;

  /// [onLoading] is called when when list state is [ListLoading]
  /// [onRefreshing] is called when when list state is [ListRefreshing]. When
  /// callback is not provided [onResult] callback will be executed.
  /// [onResult] is called when when list state is [ListLoaded].
  /// [onNoResult] is called when when list state is [ListLoadedEmpty].
  /// [onError] is called when when list state is [ListNotLoaded].
  const ListViewBuilder({
    LoadingCallback onLoading,
    RefreshCallback<T> onRefreshing,
    ResultCallback<T> onResult,
    NoResultCallback onNoResult,
    ErrorCallback onError,
  })
      : this._onLoading = onLoading,
        this._onRefreshing = onRefreshing,
        this._onResult = onResult,
        this._onNoResult = onNoResult,
        this._onError = onError;

  /// Creates a widget based on provided callbacks and state.
  Widget build(BuildContext context, ListState state) {
    if (state is ListLoading)
      return _onLoading?.call(context) ?? Container();
    else if (state is ListRefreshing)
      return _onRefreshing != null
          ? _onRefreshing.call(context, state.elements)
          : _onResult?.call(context, state.elements) ?? Container();
    else if (state is ListNotLoaded)
      return _onError?.call(context, state.exception) ?? Container();
    else if (state is ListLoaded<T>)
      return _onResult?.call(context, state.elements) ?? Container();
    else
      return _onNoResult?.call(context) ?? Container();
  }
}
