// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'view_state_builder_util.dart';
import 'view_state_fakes.dart';
import 'view_state_matchers.dart';

class TestBlocMock extends MockBloc<int, ViewState> {}

void main() {
  late TestBlocMock bloc;
  const someData = 0;
  final someError = Exception();

  setUpAll(() {
    registerBuildContextFallbackValue();
  });

  setUp(() {
    bloc = TestBlocMock();
  });

  testWidgets(
      'should display onReady widget '
      'when Bloc in initial state '
      'and NO state changes occurs', (WidgetTester tester) async {
    whenListen(bloc, Stream<ViewState>.empty(), initialState: Initial());
    await tester.pumpViewStateBuilder(bloc);
    verifyReadyWidgetIsDisplayed();
  });

  testWidgets(
      'should display ready and loading widgets '
      'when Bloc emits [Initial, Loading] states', (WidgetTester tester) async {
    whenListen(bloc, Stream.value(Loading()), initialState: Initial());
    await tester.pumpViewStateBuilder(bloc);
    verifyReadyWidgetIsDisplayed();
    await tester.pump();
    verifyLoadingWidgetIsDisplayed();
  });

  testWidgets(
      'should display success and refreshing widgets '
      'when Bloc emits [Success, Refreshing] states',
      (WidgetTester tester) async {
    whenListen(
      bloc,
      Stream.value(Refreshing(someData)),
      initialState: Success(someData),
    );
    await tester.pumpViewStateBuilder(bloc);
    verifySuccessWidgetIsDisplayed();
    await tester.pump();
    verifyRefreshWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and empty widgets '
      'when Bloc emits [Loading, Empty] states', (WidgetTester tester) async {
    whenListen(bloc, Stream.value(Empty()), initialState: Loading());
    await tester.pumpViewStateBuilder(bloc);
    verifyLoadingWidgetIsDisplayed();
    await tester.pump();
    verifyEmptyWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and success widgets '
      'when Bloc emits [Loading, Success] states', (WidgetTester tester) async {
    whenListen(bloc, Stream.value(Success(someData)), initialState: Loading());
    await tester.pumpViewStateBuilder(bloc);
    verifyLoadingWidgetIsDisplayed();
    await tester.pump();
    verifySuccessWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and error widgets '
      'when Bloc emits [Loading, Failure] states', (WidgetTester tester) async {
    whenListen(bloc, Stream.value(Failure(someError)), initialState: Loading());
    await tester.pumpViewStateBuilder(bloc);
    verifyLoadingWidgetIsDisplayed();
    await tester.pump();
    verifyErrorWidgetIsDisplayed();
  });

  tearDown(() {
    bloc.close();
  });
}
