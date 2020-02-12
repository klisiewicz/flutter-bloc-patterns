import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/src/common/view_state.dart';

/// Callback function for the the initial state.
typedef InitialCallback = Widget Function(BuildContext context);

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

/// [ViewStateBuilder] is responsible for building the UI based on the [ViewState].
/// It's a wrapper over the [BlocBuilder] widget so it accepts a [bloc] object and
/// a set of handy callbacks, which corresponds to each possible state:
/// [onReady] callback for the the initial state,
/// [onLoading] callback for the data loading state,
/// [onRefreshing] callback for the data refreshing state,
/// [onSuccess] callback for the data success state,
/// [onEmpty] callback for for no result state,
/// [onError] callback function for an error state.

/// [T] - the type of list elements,
/// [B] - the type of bloc.
class ViewStateBuilder<T, B extends Bloc<dynamic, ViewState>>
    extends BlocBuilder<B, ViewState> {
  ViewStateBuilder({
    Key key,
    B bloc,
    InitialCallback onReady,
    LoadingCallback onLoading,
    RefreshingCallback<T> onRefreshing,
    SuccessCallback<T> onSuccess,
    EmptyCallback onEmpty,
    ErrorCallback onError,
    BlocBuilderCondition<ViewState> condition,
  }) : super(
          key: key,
          bloc: bloc,
          condition: condition,
          builder: (BuildContext context, ViewState state) {
            if (state is Initial) {
              return onReady?.call(context) ?? const SizedBox();
            } else if (state is Loading) {
              return onLoading?.call(context) ?? const SizedBox();
            } else if (state is Refreshing<T>) {
              return onRefreshing?.call(context, state.data) ??
                  const SizedBox();
            } else if (state is Success<T>) {
              return onSuccess?.call(context, state.data) ?? const SizedBox();
            } else if (state is Empty) {
              return onEmpty?.call(context) ?? const SizedBox();
            } else if (state is Failure) {
              return onError?.call(context, state.error) ?? const SizedBox();
            } else {
              return const SizedBox();
            }
          },
        );
}
