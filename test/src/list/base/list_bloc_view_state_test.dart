import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/widget_tester_ext.dart';
import '../../view/view_state_builder_util.dart';
import '../../view/view_state_matchers.dart';
import '../filter/filter_list_repository_mock.dart';

void main() {
  testWidgets(
      'should display initial widget when items has NOT been loaded yet',
      (tester) async {
    final listBloc = ListBloc(
      InMemoryFilterRepository(['Hello']),
    );
    await tester.pumpViewStateBuilder(listBloc);
    verifyInitialWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and data widgets when loading items succeeds',
      (tester) async {
    final listBloc = ListBloc(InMemoryFilterRepository(['Hello']));
    await tester.pumpViewStateBuilder(listBloc);

    listBloc.loadItems();
    await tester.pump();
    verifyLoadingWidgetIsDisplayed();

    await tester.asyncPump();
    verifyDataWidgetIsDisplayed();
  });

  testWidgets('should display loading and empty widgets when list is empty',
      (tester) async {
    final listBloc = ListBloc(
      InMemoryFilterRepository(<String>[]),
    );
    await tester.pumpViewStateBuilder(listBloc);

    listBloc.loadItems();
    await tester.pump();
    verifyLoadingWidgetIsDisplayed();

    await tester.asyncPump();
    verifyEmptyWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and error widgets when loading items fails',
      (tester) async {
    final listBloc = ListBloc(
      FailingFilterRepository<String, String>(Exception()),
    );
    await tester.pumpViewStateBuilder(listBloc);

    listBloc.loadItems();
    await tester.pump();
    verifyLoadingWidgetIsDisplayed();

    await tester.asyncPump();
    verifyErrorWidgetIsDisplayed();
  });
}
