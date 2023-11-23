// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'view_state_builder_util.dart';
import 'view_state_fakes.dart';
import 'view_state_matchers.dart';

class TestMockBloc extends MockBloc<int, TestState> {}

typedef TestState = ViewState<String>;

void main() {
  late TestMockBloc bloc;
  const someData = 'Hello';
  final someError = Exception();

  setUpAll(() {
    registerBuildContextFallbackValue();
  });

  setUp(() {
    bloc = TestMockBloc();
  });

  testWidgets(
      'should display initial widget when created Bloc does NOT emit any states',
      (WidgetTester tester) async {
    whenListen<TestState>(bloc, Stream.empty(), initialState: Initial());
    await tester.pumpViewStateBuilder(bloc);
    verifyReadyWidgetIsDisplayed();
  });

  testWidgets(
      'should display initial and loading widgets when Bloc emits [Initial, Loading] states',
      (WidgetTester tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(Loading()),
      initialState: Initial(),
    );
    await tester.pumpViewStateBuilder(bloc);
    verifyReadyWidgetIsDisplayed();
    await tester.pump();
    verifyLoadingWidgetIsDisplayed();
  });

  testWidgets(
      'should display data and refreshing widgets when Bloc emits [Data, Refreshing] states',
      (WidgetTester tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(Refreshing(someData)),
      initialState: Data(someData),
    );
    await tester.pumpViewStateBuilder(bloc);
    verifySuccessWidgetIsDisplayed();
    await tester.pump();
    verifyRefreshWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and empty widgets when Bloc emits [Loading, Empty] states',
      (WidgetTester tester) async {
    whenListen<TestState>(bloc, Stream.value(Empty()), initialState: Loading());
    await tester.pumpViewStateBuilder(bloc);
    verifyLoadingWidgetIsDisplayed();
    await tester.pump();
    verifyEmptyWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and data widgets when Bloc emits [Loading, Success] states',
      (WidgetTester tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(Data(someData)),
      initialState: Loading(),
    );
    await tester.pumpViewStateBuilder(bloc);
    verifyLoadingWidgetIsDisplayed();
    await tester.pump();
    verifySuccessWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and error widgets when Bloc emits [Loading, Failure] states',
      (WidgetTester tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(Failure(someError)),
      initialState: Loading(),
    );
    await tester.pumpViewStateBuilder(bloc);
    verifyLoadingWidgetIsDisplayed();
    await tester.pump();
    verifyErrorWidgetIsDisplayed();
  });

  tearDown(() {
    bloc.close();
  });
}
