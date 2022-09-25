import 'package:flutter_bloc_patterns/src/details/details_bloc.dart';
import 'package:flutter_bloc_patterns/src/details/details_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../util/mocktail_ext.dart';
import '../util/widget_tester_ext.dart';
import '../view/view_state_builder_util.dart';
import '../view/view_state_matchers.dart';

class DetailsRepositoryMock extends Mock
    implements DetailsRepository<int, int> {}

void main() {
  const someData = 0;
  late DetailsRepositoryMock repository;
  late DetailsBloc<int, int> bloc;

  setUp(() {
    repository = DetailsRepositoryMock();
    bloc = DetailsBloc(repository);
  });

  testWidgets(
      'GIVEN Bloc in initial state '
      'WHEN no actions have been executed '
      'THEN should display onReady widget ', (WidgetTester tester) async {
    await tester.pumpViewStateBuilder(bloc);
    verifyReadyWidgetIsDisplayed();
  });

  testWidgets(
      'GIVEN an item '
      'WHEN loading item '
      'THEN should display ready, loading and success widgets',
      (WidgetTester tester) async {
    when(() => repository.getById(someData)).thenAnswerFutureValue(someData);
    await tester.pumpViewStateBuilder(bloc);
    bloc.loadItem(someData);
    await tester.asyncPump();
    verifyLoadingWidgetIsDisplayed();
    await tester.asyncPump();
    verifySuccessWidgetIsDisplayed();
  });

  testWidgets(
      'GIVEN NO item '
      'WHEN loading item '
      'THEN should display ready, loading and empty widgets',
      (WidgetTester tester) async {
    when(() => repository.getById(someData)).thenAnswerFutureValue(null);
    await tester.pumpViewStateBuilder(bloc);
    bloc.loadItem(someData);
    await tester.asyncPump();
    verifyLoadingWidgetIsDisplayed();
    await tester.asyncPump();
    verifyEmptyWidgetIsDisplayed();
  });

  testWidgets(
      'GIVEN an error '
      'WHEN loading item '
      'THEN should display ready, loading and error widgets',
      (WidgetTester tester) async {
    when(() => repository.getById(someData)).thenAnswerError(Exception());
    await tester.pumpViewStateBuilder(bloc);
    bloc.loadItem(someData);
    await tester.asyncPump();
    verifyLoadingWidgetIsDisplayed();
    await tester.asyncPump();
    verifyErrorWidgetIsDisplayed();
  });

  tearDown(() {
    bloc.close();
  });
}
