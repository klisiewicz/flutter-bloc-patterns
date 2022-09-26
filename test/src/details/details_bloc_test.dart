import 'package:flutter_bloc_patterns/details.dart';
import 'package:flutter_bloc_patterns/src/details/details_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'details_repository_mock.dart';

void main() {
  late DetailsBloc<String, int> detailsBloc;

  Future<void> thenExpectStates(Iterable<ViewState> states) async {
    expect(
      detailsBloc.stream,
      emitsInOrder(states),
    );
  }

  group('repository with items', () {
    const existingId = 1;
    const noneExistingId = -1;
    const someData = 'Hello Word';

    setUp(() {
      detailsBloc = DetailsBloc(
        InMemoryDetailsRepository<String, int>({
          existingId: someData,
        }),
      );
    });

    void whenLoadingExistingElement() => detailsBloc.loadItem(existingId);

    void whenLoadingNoneExistingElement() =>
        detailsBloc.loadItem(noneExistingId);

    test('should be initialized in $Initial state', () {
      expect(detailsBloc.state, equals(const Initial()));
    });

    test(
        'should emit [$Loading, $Empty] when there is no element with given id',
        () {
      whenLoadingNoneExistingElement();
      thenExpectStates(const [
        Loading(),
        Empty(),
      ]);
    });

    test(
        'should emit [$Loading, $Success] when there is an element with given id',
        () {
      whenLoadingExistingElement();
      thenExpectStates(const [
        Loading(),
        Success(someData),
      ]);
    });

    tearDown(() {
      detailsBloc.close();
    });
  });

  group('failing repository', () {
    final exception = Exception('Oh no!');
    final error = Error();

    void givenFailingRepository(Object error) =>
        detailsBloc = DetailsBloc(FailingDetailsRepository(error));

    void whenLoadingElement() => detailsBloc.loadItem(0);

    test('should emit [$Loading, $Failure] when fetching element fails', () {
      givenFailingRepository(exception);
      whenLoadingElement();
      thenExpectStates([
        const Loading(),
        Failure(exception),
      ]);
    });

    test('should emit [$Loading, $Failure] when an error is thrown', () {
      givenFailingRepository(error);
      whenLoadingElement();
      thenExpectStates([
        const Loading(),
        Failure(error),
      ]);
    });

    tearDown(() {
      detailsBloc.close();
    });
  });
}
