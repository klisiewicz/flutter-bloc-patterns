import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';

/// Callback function for the data loading state.
typedef LoadingCallback = void Function(BuildContext context);

/// Callback function for a success. The data was fetched and nonnull
/// element was returned.
@Deprecated('This type will be removed. Use the "DataCallback" instead.')
typedef SuccessCallback<T> = void Function(BuildContext context, T data);

/// Callback function for a success. The data was fetched and nonnull
/// element was returned.
typedef DataCallback<T> = void Function(BuildContext context, T data);

/// Callback function for the data refreshing state
typedef RefreshingCallback<T> = void Function(BuildContext context, T data);

/// Callback function for no result. The data was fetched
/// successfully, but a null element was returned.
typedef EmptyCallback = void Function(BuildContext context);

/// Callback function for an error. It contains an [error] that has caused
/// which may allow a view to react differently on different errors.
typedef ErrorCallback = void Function(BuildContext context, Object error);

/// Signature for the [listenWhen] function which takes the previous [ViewState]
/// and the current [ViewState] and is responsible for returning a [bool] which
/// determines whether or not to call the [listener] function.
typedef ViewStateListenerCondition = bool Function(
  ViewState previous,
  ViewState current,
);

/// [ViewStateListener] is responsible for performing an action based on the
/// [ViewState].
///
/// It should be used for functionality that needs to occur only in response to
/// a [state] change such as navigation, showing a [SnackBar], showing
/// a [Dialog], etc.
///
/// [ViewStateListener] is a wrapper over the [BlocListener] widget so it accepts
/// a [bloc] object as well as a [child] widget and a set of handy callbacks
/// corresponding to a given state:
/// [onLoading] callback for the data loading state,
/// [onRefreshing] callback for the data refreshing state,
/// [onData] callback for the data success state,
/// [onEmpty] callback for for no result state,
/// [onError] callback function for an error state.
///
/// [T] - the type of items,
/// [B] - the type of bloc.
class ViewStateListener<T, B extends BlocBase<ViewState<T>>>
    extends BlocListener<B, ViewState<T>> {
  ViewStateListener({
    super.key,
    super.bloc,
    super.listenWhen,
    LoadingCallback? onLoading,
    RefreshingCallback<T>? onRefreshing,
    @Deprecated('This callback will removed. Use "onData" instead.')
    SuccessCallback<T>? onSuccess,
    DataCallback<T>? onData,
    EmptyCallback? onEmpty,
    ErrorCallback? onError,
    super.child,
  })  : assert(
          !(onSuccess != null && onData != null),
          'The onSuccess and onData callbacks should NOT be used together. The onSuccess callback is deprecated and can be safely removed.',
        ),
        super(
          listener: (BuildContext context, ViewState<T> state) {
            return switch (state) {
              Initial<T>() => () {},
              Loading<T>() => onLoading?.call(context),
              Refreshing<T>(value: final value) =>
                onRefreshing?.call(context, value),
              Data<T>(value: final value) =>
                (onData ?? onSuccess)?.call(context, value),
              Empty<T>() => onEmpty?.call(context),
              Failure<T>(error: final value) => onError?.call(context, value)
            };
          },
        );
}
