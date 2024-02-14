import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_bloc_patterns/src/view/view_state_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util/view_test_util.dart';
import 'view_state_keys.dart';

extension WidgetTesterViewStateExt on WidgetTester {
  Future<void> pumpViewStateBuilder<T, B extends BlocBase<ViewState<T>>>(
    B bloc,
  ) {
    return pumpWidget(
      makeTestableViewStateBuilder<T, B>(bloc),
    );
  }
}

Widget makeTestableViewStateBuilder<T, B extends BlocBase<ViewState<T>>>(
  B bloc,
) {
  return makeTestableWidget(
    child: ViewStateBuilder<T, B>(
      bloc: bloc,
      initial: (context) => const SizedBox.shrink(key: initialKey),
      loading: (context) => const SizedBox.shrink(key: loadKey),
      refreshing: (context, data) => const SizedBox.shrink(key: refreshKey),
      empty: (context) => const SizedBox.shrink(key: emptyKey),
      data: (context, data) => const SizedBox.shrink(key: dataKey),
      error: (context, error) => const SizedBox.shrink(key: errorKey),
    ),
  );
}
