import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';

/// Builder function for the the initial state.
typedef InitialBuilder = Widget Function(BuildContext context);

/// Builder function for the data loading state.
typedef LoadingBuilder = Widget Function(BuildContext context);

/// Builder function for a success state. The data was fetched and nonnull
/// element was returned.
@Deprecated('This type will be removed. Use the "DataBuilder" instead.')
typedef SuccessBuilder<T> = Widget Function(BuildContext context, T data);

/// Builder function for a success state. The data was fetched and nonnull
/// element was returned.
typedef DataBuilder<T> = Widget Function(BuildContext context, T data);

/// Builder function for the data refreshing state. Can only occur after
/// [DataBuilder].
typedef RefreshingBuilder<T> = Widget Function(BuildContext context, T data);

/// Builder function for no result. The data was fetched
/// successfully, but a null element was returned.
typedef EmptyBuilder = Widget Function(BuildContext context);

/// Builder function for an error. It contains an [error] that has caused
/// which may allow a view to react differently on different errors.
typedef ErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
);

/// Signature for the [buildWhen] function which takes the previous [ViewState]
/// and the current [ViewState] and returns a [bool] which determines whether
/// to rebuild the `view` with the current `state`.
typedef ViewStateBuilderCondition<T> = bool Function(
  ViewState<T> previous,
  ViewState<T> current,
);

/// [ViewStateBuilder] is responsible for building the UI based on the [ViewState].
/// It's a wrapper over the [BlocBuilder] widget so it accepts a [bloc] object and
/// a set of handy callbacks, which corresponds to each possible state:
/// [initial] builder for the the initial state,
/// [loading] builder for the data loading state,
/// [refreshing] builder for the data refreshing state,
/// [data] builder for the data state,
/// [empty] builder for for no result state,
/// [error] builder function for an error state.
/// [buildWhen] a condition to determine whether to rebuild the `view` with the current `state`
///
/// [T] - the type of items,
/// [B] - the type of bloc.
class ViewStateBuilder<T, B extends BlocBase<ViewState<T>>>
    extends BlocBuilder<B, ViewState<T>> {
  ViewStateBuilder({
    super.key,
    super.bloc,
    @Deprecated('This builder will be removed. Use "initial" instead.')
    InitialBuilder? onReady,
    InitialBuilder? initial,
    @Deprecated('This builder will be removed. Use "loading" instead.')
    LoadingBuilder? onLoading,
    LoadingBuilder? loading,
    @Deprecated('This builder removed. Use "refreshing" instead.')
    RefreshingBuilder<T>? onRefreshing,
    RefreshingBuilder<T>? refreshing,
    @Deprecated('This builder removed. Use "data" instead.')
    SuccessBuilder<T>? onSuccess,
    DataBuilder<T>? data,
    @Deprecated('This builder removed. Use "none" instead.')
    EmptyBuilder? onEmpty,
    EmptyBuilder? empty,
    @Deprecated('This builder removed. Use "none" instead.')
    ErrorBuilder? onError,
    ErrorBuilder? error,
    super.buildWhen,
  })  : assert(
          !(onReady != null && initial != null),
          'The onReady and initial builders should NOT be used together. The onReady builder is deprecated and can be safely removed.',
        ),
        assert(
          !(onLoading != null && loading != null),
          'The onLoading and loading builders should NOT be used together. The onLoading builder is deprecated and can be safely removed.',
        ),
        assert(
          !(onRefreshing != null && refreshing != null),
          'The onRefreshing and refreshing builders should NOT be used together. The onRefreshing builder is deprecated and can be safely removed.',
        ),
        assert(
          !(onSuccess != null && data != null),
          'The onSuccess and data builders should NOT be used together. The onSuccess builder is deprecated and can be safely removed.',
        ),
        assert(
          !(onEmpty != null && empty != null),
          'The onEmpty and empty builders should NOT be used together. The onEmpty builder is deprecated and can be safely removed.',
        ),
        assert(
          !(onError != null && error != null),
          'The onEmpty and error builders should NOT be used together. The onError builder is deprecated and can be safely removed.',
        ),
        super(
          builder: (BuildContext context, ViewState<T> state) {
            const none = SizedBox.shrink();
            return switch (state) {
              Initial<T>() =>
                (initial?.call(context) ?? onReady?.call(context)) ?? none,
              Loading<T>() =>
                (loading?.call(context) ?? onLoading?.call(context)) ?? none,
              Refreshing<T>(value: final value) =>
                (refreshing?.call(context, value) ??
                        onRefreshing?.call(context, value)) ??
                    none,
              Data<T>(value: final value) => (data?.call(context, value) ??
                      onSuccess?.call(context, value)) ??
                  none,
              Empty<T>() =>
                (empty?.call(context) ?? onEmpty?.call(context)) ?? none,
              Failure<T>(error: final value) => (error?.call(context, value) ??
                      onError?.call(context, value)) ??
                  none,
            };
          },
        );
}
