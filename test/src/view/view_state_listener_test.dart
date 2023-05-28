import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../util/view_test_util.dart';
import 'view_state_fakes.dart';

class MockTestBloc extends MockBloc<int, ViewState> {}

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
  late Bloc<int, ViewState> bloc;
  late LoadingCallback loadingCallback;
  late SuccessCallback<int> successCallback;
  late RefreshingCallback<int> refreshCallback;
  late EmptyCallback emptyCallback;
  late ErrorCallback errorCallback;

  setUpAll(() {
    registerBuildContextFallbackValue();
  });

  setUp(() {
    bloc = MockTestBloc();
    loadingCallback = LoadingMock().call;
    successCallback = SuccessMock().call;
    refreshCallback = RefreshMock().call;
    emptyCallback = EmptyMock().call;
    errorCallback = ErrorMock().call;
  });

  Widget makeTestableViewStateListener() {
    return makeTestableWidget(
      child: ViewStateListener<int, Bloc<int, ViewState>>(
        bloc: bloc,
        onLoading: loadingCallback,
        onRefreshing: refreshCallback,
        onSuccess: successCallback,
        onEmpty: emptyCallback,
        onError: errorCallback,
        child: const SizedBox(),
      ),
    );
  }

  testWidgets('should invoke loading callback when loading',
      (WidgetTester tester) async {
    whenListen(
      bloc,
      Stream.value(const Loading()),
      initialState: const Initial(),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verify(() => loadingCallback.call(any<BuildContext>()));
    verifyNever(() => successCallback.call(any<BuildContext>(), any<int>()));
    verifyNever(() => refreshCallback.call(any<BuildContext>(), any<int>()));
    verifyNever(() => emptyCallback.call(any<BuildContext>()));
    verifyNever(() => errorCallback.call(any<BuildContext>(), any<Object>()));
  });

  testWidgets('should invoke success callback when loaded',
      (WidgetTester tester) async {
    whenListen(
      bloc,
      Stream.value(const Success(_someData)),
      initialState: const Initial(),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verifyNever(() => loadingCallback.call(any()));
    verify(() => successCallback.call(any(), _someData));
    verifyNever(() => refreshCallback.call(any(), any()));
    verifyNever(() => emptyCallback.call(any()));
    verifyNever(() => errorCallback.call(any(), any()));
  });

  testWidgets('should invoke refresh callback when refreshing',
      (WidgetTester tester) async {
    whenListen(
      bloc,
      Stream.value(const Refreshing(_someData)),
      initialState: const Initial(),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verifyNever(() => loadingCallback.call(any()));
    verifyNever(() => successCallback.call(any(), any()));
    verify(() => refreshCallback.call(any(), _someData));
    verifyNever(() => emptyCallback.call(any()));
    verifyNever(() => errorCallback.call(any(), any()));
  });

  testWidgets('should invoke empty callback when empty',
      (WidgetTester tester) async {
    whenListen(
      bloc,
      Stream.value(const Empty()),
      initialState: const Initial(),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verifyNever(() => loadingCallback.call(any()));
    verifyNever(() => successCallback.call(any(), any()));
    verifyNever(() => refreshCallback.call(any(), any()));
    verify(() => emptyCallback.call(any()));
    verifyNever(() => errorCallback.call(any(), any()));
  });

  testWidgets('should invoke error callback when error',
      (WidgetTester tester) async {
    whenListen(
      bloc,
      Stream.value(Failure(_someException)),
      initialState: const Initial(),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verifyNever(() => loadingCallback.call(any()));
    verifyNever(() => successCallback.call(any(), any()));
    verifyNever(() => refreshCallback.call(any(), any()));
    verifyNever(() => emptyCallback.call(any()));
    verify(() => errorCallback.call(any(), _someException));
  });

  tearDown(() {
    bloc.close();
  });
}
