import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_patterns/src/common/state.dart';
import 'package:flutter_bloc_patterns/src/common/state.dart' as view;

/// Callback function for the data loading state.
typedef LoadingCallback = Widget Function(BuildContext context);

/// Callback function for a success. The data was fetched and nonnull
/// element was returned.
typedef SuccessCallback<T> = Widget Function(BuildContext context, T data);

/// Callback function for the data refreshing state. Can only occur after
/// [SuccessCallback].
typedef RefreshingCallback<T> = Widget Function(BuildContext context, T data);

/// Callback function for no result. The data was fetched
/// successfully, but a null element was returned.
typedef EmptyCallback = Widget Function(BuildContext context);

/// Callback function for an error. It contains an [error] that has caused
/// which may allow a view to react differently on different errors.
typedef ErrorCallback = Widget Function(
  BuildContext context,
  dynamic error,
);

class ViewStateBuilder<T> {
  final LoadingCallback _onLoading;
  final RefreshingCallback<T> _onRefreshing;
  final SuccessCallback<T> _onSuccess;
  final EmptyCallback _onEmpty;
  final ErrorCallback _onError;

  const ViewStateBuilder({
    LoadingCallback onLoading,
    RefreshingCallback<T> onRefreshing,
    SuccessCallback<T> onSuccess,
    EmptyCallback onEmpty,
    ErrorCallback onError,
  })  : this._onLoading = onLoading,
        this._onRefreshing = onRefreshing,
        this._onSuccess = onSuccess,
        this._onEmpty = onEmpty,
        this._onError = onError;

  /// Creates a widget based on provided callbacks and state.
  Widget build(BuildContext context, view.State state) {
    if (state is Loading) {
      return _onLoading?.call(context) ?? Container();
    } else if (state is Refreshing<T>) {
      return _onRefreshing?.call(context, state.data) ?? Container();
    } else if (state is Success<T>) {
      return _onSuccess?.call(context, state.data) ?? Container();
    } else if (state is Empty) {
      return _onEmpty?.call(context) ?? Container();
    } else if (state is Failure) {
      return _onError?.call(context, state.error) ?? Container();
    } else {
      return Container();
    }
  }
}
