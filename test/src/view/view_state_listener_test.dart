import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_bloc_patterns/view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../util/view_test_util.dart';

class MockTestBloc extends MockBloc<ViewState> implements Bloc<int, ViewState> {
}

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
  Bloc<int, ViewState> bloc;
  LoadingCallback loadingCallback;
  SuccessCallback<int> successCallback;
  RefreshingCallback<int> refreshCallback;
  EmptyCallback emptyCallback;
  ErrorCallback errorCallback;

  setUp(() {
    bloc = MockTestBloc();
    loadingCallback = LoadingMock();
    successCallback = SuccessMock();
    refreshCallback = RefreshMock();
    emptyCallback = EmptyMock();
    errorCallback = ErrorMock();
  });

  Widget makeTestableViewStateListener() {
    return makeTestableWidget(
      child: ViewStateListener<int, Bloc<int, ViewState>>(
        cubit: bloc,
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
      Stream.fromIterable(const [Initial(), Loading()]),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verify(loadingCallback.call(any));
    verifyNever(successCallback.call(any, any));
    verifyNever(refreshCallback.call(any, any));
    verifyNever(emptyCallback.call(any));
    verifyNever(errorCallback.call(any, any));
  });

  testWidgets('should invoke success callback when loaded',
      (WidgetTester tester) async {
    whenListen(
      bloc,
      Stream.fromIterable(const [Initial(), Success(_someData)]),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verifyNever(loadingCallback.call(any));
    verify(successCallback.call(any, _someData));
    verifyNever(refreshCallback.call(any, any));
    verifyNever(emptyCallback.call(any));
    verifyNever(errorCallback.call(any, any));
  });

  testWidgets('should invoke refresh callback when refreshing',
      (WidgetTester tester) async {
    whenListen(
      bloc,
      Stream.fromIterable(const [Initial(), Refreshing(_someData)]),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verifyNever(loadingCallback.call(any));
    verifyNever(successCallback.call(any, any));
    verify(refreshCallback.call(any, _someData));
    verifyNever(emptyCallback.call(any));
    verifyNever(errorCallback.call(any, any));
  });

  testWidgets('should invoke empty callback when empty',
      (WidgetTester tester) async {
    whenListen(
      bloc,
      Stream.fromIterable(const [Initial(), Empty()]),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verifyNever(loadingCallback.call(any));
    verifyNever(successCallback.call(any, any));
    verifyNever(refreshCallback.call(any, any));
    verify(emptyCallback.call(any));
    verifyNever(errorCallback.call(any, any));
  });

  testWidgets('should invoke error callback when error',
      (WidgetTester tester) async {
    whenListen(
      bloc,
      Stream.fromIterable([const Initial(), Failure(_someException)]),
    );

    await tester.pumpWidget(makeTestableViewStateListener());

    verifyNever(loadingCallback.call(any));
    verifyNever(successCallback.call(any, any));
    verifyNever(refreshCallback.call(any, any));
    verifyNever(emptyCallback.call(any));
    verify(errorCallback.call(any, _someException));
  });
}
