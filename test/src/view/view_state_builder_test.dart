import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'view_state_builder_util.dart';
import 'view_state_keys.dart';

class MockTestBloc extends MockBloc<ViewState> implements Bloc<int, ViewState> {
}

void main() {
  Bloc<int, ViewState> bloc;
  const someData = 0;
  final someError = Exception();

  setUp(() {
    bloc = MockTestBloc();
  });

  testWidgets('should display onReady widget when bloc is in initial state',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(const Initial());

    await tester.pumpWidget(makeTestableViewStateBuilder(bloc));

    expect(find.byKey(readyKey), findsOneWidget);
  });

  testWidgets('should display onLoading widget when bloc is in loading state',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(const Loading());

    await tester.pumpWidget(makeTestableViewStateBuilder(bloc));

    expect(find.byKey(loadKey), findsOneWidget);
  });

  testWidgets(
      'should display onRefreshing widget when bloc is in refreshing state',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(const Refreshing(someData));

    await tester.pumpWidget(makeTestableViewStateBuilder(bloc));

    expect(find.byKey(refreshKey), findsOneWidget);
  });

  testWidgets('should display onEmpty widget when bloc is in empty state',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(const Empty());

    await tester.pumpWidget(makeTestableViewStateBuilder(bloc));

    expect(find.byKey(emptyKey), findsOneWidget);
  });

  testWidgets('should display onSuccess widget when bloc is in success state',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(const Success(someData));

    await tester.pumpWidget(makeTestableViewStateBuilder(bloc));

    expect(find.byKey(successKey), findsOneWidget);
  });

  testWidgets('should display onError widget when bloc is in failure state',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(Failure(someError));

    await tester.pumpWidget(makeTestableViewStateBuilder(bloc));

    expect(find.byKey(errorKey), findsOneWidget);
  });

  tearDown(() {
    bloc.close();
  });
}
