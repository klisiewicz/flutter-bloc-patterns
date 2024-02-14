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

  setUpAll(() {
    registerBuildContextFallbackValue();
  });

  setUp(() {
    bloc = TestMockBloc();
  });

  testWidgets(
      'should display initial widget when created Bloc does NOT emit any states',
      (tester) async {
    whenListen<TestState>(
      bloc,
      Stream.empty(),
      initialState: Initial(),
    );

    await tester.pumpViewStateBuilder(bloc);

    verifyInitialWidgetIsDisplayed();
  });

  testWidgets(
      'should display initial and loading widgets when Bloc emits [Initial, Loading] states',
      (tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(Loading()),
      initialState: Initial(),
    );
    await tester.pumpViewStateBuilder(bloc);

    verifyInitialWidgetIsDisplayed();
    await tester.pump();

    verifyLoadingWidgetIsDisplayed();
  });

  testWidgets(
      'should display data and refreshing widgets when Bloc emits [Data, Refreshing] states',
      (tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(Refreshing('Hello')),
      initialState: Data('Hello'),
    );
    await tester.pumpViewStateBuilder(bloc);

    verifyDataWidgetIsDisplayed();
    await tester.pump();

    verifyRefreshWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and empty widgets when Bloc emits [Loading, Empty] states',
      (tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(Empty()),
      initialState: Loading(),
    );
    await tester.pumpViewStateBuilder(bloc);

    verifyLoadingWidgetIsDisplayed();
    await tester.pump();

    verifyEmptyWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and data widgets when Bloc emits [Loading, Data] states',
      (tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(Data('Hello')),
      initialState: Loading(),
    );
    await tester.pumpViewStateBuilder(bloc);

    verifyLoadingWidgetIsDisplayed();
    await tester.pump();

    verifyDataWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and error widgets when Bloc emits [Loading, Failure] states',
      (tester) async {
    whenListen<TestState>(
      bloc,
      Stream.value(Failure(Exception('What happened?'))),
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
