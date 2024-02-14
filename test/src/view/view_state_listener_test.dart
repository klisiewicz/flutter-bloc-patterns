import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_bloc_patterns/view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../util/view_test_util.dart';
import 'view_state_fakes.dart';

class TestMockBloc extends MockBloc<int, TestState> {}

typedef TestState = ViewState<int>;

class LoadingMock extends Mock {
  void call(BuildContext context);
}

class SuccessMock extends Mock {
  void call(BuildContext context, int data);
}

class RefreshMock extends Mock {
  void call(BuildContext context, int data);
}

class EmptyMock extends Mock {
  void call(BuildContext context);
}

class ErrorMock extends Mock {
  void call(BuildContext context, dynamic error);
}

const _someData = 1;
final _someException = Exception('Damn, I have failed...');

void main() {
  late Bloc<int, TestState> bloc;
  late LoadingCallback onLoading;
  late DataCallback<int> onData;
  late RefreshingCallback<int> onRefreshing;
  late EmptyCallback onEmpty;
  late ErrorCallback onError;

  setUpAll(() {
    registerBuildContextFallbackValue();
  });

  setUp(() {
    bloc = TestMockBloc();
    onLoading = LoadingMock().call;
    onData = SuccessMock().call;
    onRefreshing = RefreshMock().call;
    onEmpty = EmptyMock().call;
    onError = ErrorMock().call;
  });

  Widget makeTestableViewStateListener() {
    return makeTestableWidget(
      child: ViewStateListener<int, Bloc<int, TestState>>(
        bloc: bloc,
        onLoading: onLoading,
        onRefreshing: onRefreshing,
        onData: onData,
        onEmpty: onEmpty,
        onError: onError,
        child: const SizedBox(),
      ),
    );
  }

  testWidgets('should invoke onLoading callback when loading', (tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(const Loading()),
      initialState: const Initial(),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verify(() => onLoading.call(any<BuildContext>()));
    verifyNever(() => onData.call(any<BuildContext>(), any<int>()));
    verifyNever(() => onRefreshing.call(any<BuildContext>(), any<int>()));
    verifyNever(() => onEmpty.call(any<BuildContext>()));
    verifyNever(() => onError.call(any<BuildContext>(), any<Object>()));
  });

  testWidgets('should invoke onData callback when loaded', (tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(const Data(_someData)),
      initialState: const Loading(),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verifyNever(() => onLoading.call(any<BuildContext>()));
    verify(() => onData.call(any<BuildContext>(), _someData));
    verifyNever(() => onRefreshing.call(any<BuildContext>(), any<int>()));
    verifyNever(() => onEmpty.call(any<BuildContext>()));
    verifyNever(() => onError.call(any<BuildContext>(), any<Object>()));
  });

  testWidgets('should invoke onRefreshing callback when refreshing',
      (tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(const Refreshing(_someData)),
      initialState: const Data(_someData),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verifyNever(() => onLoading.call(any<BuildContext>()));
    verifyNever(() => onData.call(any<BuildContext>(), any<int>()));
    verify(() => onRefreshing.call(any<BuildContext>(), _someData));
    verifyNever(() => onEmpty.call(any<BuildContext>()));
    verifyNever(() => onError.call(any<BuildContext>(), any<Object>()));
  });

  testWidgets('should invoke onEmpty callback when empty', (tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(const Empty()),
      initialState: const Loading(),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verifyNever(() => onLoading.call(any<BuildContext>()));
    verifyNever(() => onData.call(any<BuildContext>(), any<int>()));
    verifyNever(() => onRefreshing.call(any<BuildContext>(), _someData));
    verify(() => onEmpty.call(any<BuildContext>()));
    verifyNever(() => onError.call(any<BuildContext>(), any<Object>()));
  });

  testWidgets('should invoke onError callback when error', (tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(Failure(_someException)),
      initialState: const Loading(),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verifyNever(() => onLoading.call(any<BuildContext>()));
    verifyNever(() => onData.call(any<BuildContext>(), any<int>()));
    verifyNever(() => onRefreshing.call(any<BuildContext>(), any<int>()));
    verifyNever(() => onEmpty.call(any<BuildContext>()));
    verify(() => onError.call(any<BuildContext>(), _someException));
  });

  tearDown(() {
    bloc.close();
  });
}
