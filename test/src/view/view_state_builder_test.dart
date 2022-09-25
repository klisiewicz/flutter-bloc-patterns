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
    registerVieStateFallbackValue();
    registerBuildContextFallbackValue();
  });

  setUp(() {
    bloc = TestBlocMock();
  });

  testWidgets(
      'GIVEN Bloc in initial state '
      'AND NO state changes occur '
      'WHEN pumping ViewStateBuilder '
      'THEN should display onReady widget', (WidgetTester tester) async {
    whenListen(bloc, Stream<ViewState>.empty(), initialState: Initial());
    await tester.pumpViewStateBuilder(bloc);
    verifyReadyWidgetIsDisplayed();
  });

  testWidgets(
      'GIVEN Bloc in initial state '
      'AND then in loading state '
      'WHEN pumping ViewStateBuilder '
      'THEN should display onReady widget '
      'AND onLoading widget afterwards', (WidgetTester tester) async {
    whenListen(bloc, Stream.value(Loading()), initialState: Initial());
    await tester.pumpViewStateBuilder(bloc);
    verifyReadyWidgetIsDisplayed();
    await tester.pump();
    verifyLoadingWidgetIsDisplayed();
  });

  testWidgets(
      'GIVEN Bloc in success state '
      'AND then in refreshing state '
      'WHEN pumping ViewStateBuilder '
      'THEN should display onReady widget '
      'AND onRefreshing widget afterwards', (WidgetTester tester) async {
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
      'GIVEN Bloc in loading state '
      'AND then in empty state '
      'WHEN pumping ViewStateBuilder '
      'THEN should display onLoading widget '
      'AND onEmpty widget afterwards', (WidgetTester tester) async {
    whenListen(bloc, Stream.value(Empty()), initialState: Loading());
    await tester.pumpViewStateBuilder(bloc);
    verifyLoadingWidgetIsDisplayed();
    await tester.pump();
    verifyEmptyWidgetIsDisplayed();
  });

  testWidgets(
      'GIVEN Bloc in loading state '
      'AND then in success state '
      'WHEN pumping ViewStateBuilder '
      'THEN should display onLoading widget '
      'AND onSuccess widget afterwards', (WidgetTester tester) async {
    whenListen(bloc, Stream.value(Success(someData)), initialState: Loading());
    await tester.pumpViewStateBuilder(bloc);
    verifyLoadingWidgetIsDisplayed();
    await tester.pump();
    verifySuccessWidgetIsDisplayed();
  });

  testWidgets(
      'GIVEN Bloc in loading state '
      'AND then in error state '
      'WHEN pumping ViewStateBuilder '
      'THEN should display onLoading widget '
      'AND onError widget afterwards', (WidgetTester tester) async {
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
