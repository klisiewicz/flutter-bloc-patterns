import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/widget_tester_ext.dart';
import '../../view/view_state_builder_util.dart';
import '../../view/view_state_matchers.dart';
import '../filter/filter_list_repository_mock.dart';

void main() {
  late ListBloc<int> bloc;

  setUp(() {
    bloc = ListBloc(InMemoryFilterRepository());
  });

  Future<void> pumpViewStateBuilder(WidgetTester tester) {
    return tester.pumpWidget(makeTestableViewStateBuilder(bloc));
  }

  testWidgets(
      'should display onReady widget when no action has been performed by the bloc',
      (WidgetTester tester) async {
    await pumpViewStateBuilder(tester);
    expectReadyWidgetIsDisplayed();
  });

  group(
    'when loading list succeeds',
    () {
      setUp(() {
        bloc = ListBloc(InMemoryFilterRepository([1, 2, 3]));
      });

      testWidgets('then should display ready, loading and success widgets',
          (WidgetTester tester) async {
        await pumpViewStateBuilder(tester);
        expectReadyWidgetIsDisplayed();
        bloc.loadElements();
        await tester.asyncPump();
        expectLoadingWidgetIsDisplayed();
        await tester.asyncPump();
        expectSuccessWidgetIsDisplayed();
      });
    },
  );

  group(
    'when list is empty',
    () {
      setUp(() {
        bloc = ListBloc(InMemoryFilterRepository());
      });

      testWidgets('then should display ready, loading and empty widgets',
          (WidgetTester tester) async {
        await pumpViewStateBuilder(tester);
        expectReadyWidgetIsDisplayed();
        bloc.loadElements();
        await tester.asyncPump();
        expectLoadingWidgetIsDisplayed();
        await tester.asyncPump();
        expectEmptyWidgetIsDisplayed();
      });
    },
  );

  group(
    'when loading list fails',
    () {
      final someError = Exception();

      setUp(() {
        bloc = ListBloc(FailingFilterRepository(someError));
      });

      testWidgets('then should display ready, loading and error widgets',
          (WidgetTester tester) async {
        await pumpViewStateBuilder(tester);
        expectReadyWidgetIsDisplayed();
        bloc.loadElements();
        await tester.asyncPump();
        expectLoadingWidgetIsDisplayed();
        await tester.asyncPump();
        expectErrorWidgetIsDisplayed();
      });
    },
  );

  tearDown(() {
    bloc.close();
  });
}
