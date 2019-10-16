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

class ViewStateBuilder<T, B extends Bloc<dynamic, ViewState>>
    extends BlocBuilder<B, ViewState> {
  ViewStateBuilder({
    Key key,
    @required B bloc,
    InitialCallback onReady,
    LoadingCallback onLoading,
    RefreshingCallback<T> onRefreshing,
    SuccessCallback<T> onSuccess,
    EmptyCallback onEmpty,
    ErrorCallback onError,
    BlocBuilderCondition<ViewState> condition,
  })  : assert(bloc != null, 'Bloc must be provided.'),
        super(
          key: key,
          bloc: bloc,
          condition: condition,
          builder: (BuildContext context, ViewState state) {
            if (state is Initial) {
              return onReady?.call(context) ?? Container();
            } else if (state is Loading) {
              return onLoading?.call(context) ?? Container();
            } else if (state is Refreshing<T>) {
              return onRefreshing?.call(context, state.data) ?? Container();
            } else if (state is Success<T>) {
              return onSuccess?.call(context, state.data) ?? Container();
            } else if (state is Empty) {
              return onEmpty?.call(context) ?? Container();
            } else if (state is Failure) {
              return onError?.call(context, state.error) ?? Container();
            } else {
              return Container();
            }
          },
        );
}
