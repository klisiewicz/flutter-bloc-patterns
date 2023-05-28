import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/widget_tester_ext.dart';
import '../../view/view_state_builder_util.dart';
import '../../view/view_state_matchers.dart';
import '../filter/filter_list_repository_mock.dart';

void main() {
  late ListBloc<int> bloc;

  setUp(() {});

  testWidgets(
      'should display onReady widget '
      'when no action has been performed by the bloc',
      (WidgetTester tester) async {
    bloc = ListBloc(InMemoryFilterRepository());
    await tester.pumpViewStateBuilder(bloc);
    verifyReadyWidgetIsDisplayed();
  });

  testWidgets(
      'should display ready, loading and success widgets '
      'when loading list succeeds', (WidgetTester tester) async {
    bloc = ListBloc(InMemoryFilterRepository([1, 2, 3]));
    await tester.pumpViewStateBuilder(bloc);
    verifyReadyWidgetIsDisplayed();
    bloc.loadItems();
    await tester.pump();
    verifyLoadingWidgetIsDisplayed();
    await tester.asyncPump();
    verifySuccessWidgetIsDisplayed();
  });

  testWidgets(
      'should display ready, loading and empty widgets '
      'when list is empty', (WidgetTester tester) async {
    bloc = ListBloc(InMemoryFilterRepository());
    await tester.pumpViewStateBuilder(bloc);
    verifyReadyWidgetIsDisplayed();
    bloc.loadItems();
    await tester.pump();
    verifyLoadingWidgetIsDisplayed();
    await tester.asyncPump();
    verifyEmptyWidgetIsDisplayed();
  });

  testWidgets(
      'should display ready, loading and error widgets '
      'when loading list fails', (WidgetTester tester) async {
    bloc = ListBloc(FailingFilterRepository(Exception()));
    await tester.pumpViewStateBuilder(bloc);
    verifyReadyWidgetIsDisplayed();
    bloc.loadItems();
    await tester.pump();
    verifyLoadingWidgetIsDisplayed();
    await tester.asyncPump();
    verifyErrorWidgetIsDisplayed();
  });

  tearDown(() {
    bloc.close();
  });
}
