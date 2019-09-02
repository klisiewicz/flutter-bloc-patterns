import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_patterns/src/details/details_states.dart';

/// Callback function for the element loading state.
typedef LoadingCallback = Widget Function(BuildContext context);

/// Callback function for a success. The data was fetched and nonnull
/// element was returned.
typedef ResultCallback<T> = Widget Function(BuildContext context, T element);

/// Callback function for no result. The data was fetched
/// successfully a null element was returned.
typedef NoResultCallback = Widget Function(BuildContext context);

/// Callback function for an error. It contains an [Exception] that has caused
/// which may allow a view to react differently on different errors.
typedef FailureCallback = Widget Function(
  BuildContext context,
  Exception exception,
);

class DetailsViewBuilder<T> {
  final LoadingCallback _onLoading;
  final ResultCallback<T> _onResult;
  final NoResultCallback _onNoResult;
  final FailureCallback _onFailure;

  const DetailsViewBuilder({
    LoadingCallback onLoading,
    ResultCallback<T> onResult,
    NoResultCallback onNoResult,
    FailureCallback onFailure,
  })  : this._onLoading = onLoading,
        this._onResult = onResult,
        this._onNoResult = onNoResult,
        this._onFailure = onFailure;

  /// Creates a widget based on provided callbacks and state.
  Widget build(BuildContext context, DetailsState state) {
    if (state is DetailsLoading) {
      return _onLoading?.call(context) ?? Container();
    } else if (state is DetailsLoaded<T>) {
      return _onResult?.call(context, state.element) ?? Container();
    } else if (state is DetailsNotFound) {
      return _onNoResult?.call(context) ?? Container();
    } else if (state is DetailsNotLoaded) {
      return _onFailure?.call(context, state.exception) ?? Container();
    } else if (state is DetailsError) {
      throw state.error;
    } else {
      return Container();
    }
  }
}
