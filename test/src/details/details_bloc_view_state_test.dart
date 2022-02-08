import 'package:flutter_bloc_patterns/src/details/details_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util/widget_tester_ext.dart';
import '../view/view_state_builder_util.dart';
import '../view/view_state_matchers.dart';
import 'details_repository_mock.dart';

void main() {
  const someData = 0;
  late DetailsBloc<int, int> bloc;

  setUp(() {
    bloc = DetailsBloc(InMemoryDetailsRepository());
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
    'when loading details succeeds',
    () {
      setUp(() {
        bloc = DetailsBloc(InMemoryDetailsRepository({someData: someData}));
      });

      testWidgets('then should display ready, loading and success widgets',
          (WidgetTester tester) async {
        await pumpViewStateBuilder(tester);
        bloc.loadElement(someData);
        await tester.asyncPump();
        expectLoadingWidgetIsDisplayed();
        await tester.asyncPump();
        expectSuccessWidgetIsDisplayed();
      });
    },
  );

  group(
    'when no details are available',
    () {
      setUp(() {
        bloc = DetailsBloc(InMemoryDetailsRepository());
      });

      testWidgets('then should display ready, loading and empty widgets',
          (WidgetTester tester) async {
        await pumpViewStateBuilder(tester);
        bloc.loadElement(someData);
        await tester.asyncPump();
        expectLoadingWidgetIsDisplayed();
        await tester.asyncPump();
        expectEmptyWidgetIsDisplayed();
      });
    },
  );

  group(
    'when loading details fails',
    () {
      final someError = Exception();

      setUp(() {
        bloc = DetailsBloc(FailingDetailsRepository(someError));
      });

      testWidgets('then should display ready, loading and error widgets',
          (WidgetTester tester) async {
        await pumpViewStateBuilder(tester);
        bloc.loadElement(someData);
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
