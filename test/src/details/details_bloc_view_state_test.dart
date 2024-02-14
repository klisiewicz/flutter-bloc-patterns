import 'package:flutter_bloc_patterns/src/details/details_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util/widget_tester_ext.dart';
import '../view/view_state_builder_util.dart';
import '../view/view_state_matchers.dart';
import 'details_repository_mock.dart';

void main() {
  testWidgets('should display initial widget when item has NOT been loaded yet',
      (tester) async {
    final detailsBloc = DetailsBloc(
      InMemoryDetailsRepository(items: {1: 'Hello'}),
    );
    await tester.pumpViewStateBuilder(detailsBloc);

    verifyInitialWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and data widgets when loading item succeeds',
      (tester) async {
    final detailsBloc = DetailsBloc(
      InMemoryDetailsRepository(items: {1: 'Hello'}),
    );
    await tester.pumpViewStateBuilder(detailsBloc);

    detailsBloc.loadItem(1);
    await tester.pump();
    verifyLoadingWidgetIsDisplayed();

    await tester.asyncPump();
    verifyDataWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and empty widgets when loading none-existing item',
      (tester) async {
    final detailsBloc = DetailsBloc(
      InMemoryDetailsRepository(items: {1: 'Hello'}),
    );
    await tester.pumpViewStateBuilder(detailsBloc);

    detailsBloc.loadItem(2);
    await tester.pump();
    verifyLoadingWidgetIsDisplayed();

    await tester.asyncPump();
    verifyEmptyWidgetIsDisplayed();
  });

  testWidgets(
      'should display loading and error widgets when loading item fails',
      (tester) async {
    final detailsBloc = DetailsBloc(
      FailingDetailsRepository(Exception()),
    );
    await tester.pumpViewStateBuilder(detailsBloc);

    detailsBloc.loadItem(1);
    await tester.pump();
    verifyLoadingWidgetIsDisplayed();

    await tester.asyncPump();
    verifyErrorWidgetIsDisplayed();
  });
}
