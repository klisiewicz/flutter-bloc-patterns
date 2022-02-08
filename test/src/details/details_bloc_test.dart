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

  group('repository with elements', () {
    const _existingId = 1;
    const _noneExistingId = -1;
    const _someData = 'Hello Word';

    setUp(() {
      detailsBloc = DetailsBloc(
        InMemoryDetailsRepository<String, int>({
          _existingId: _someData,
        }),
      );
    });

    void whenLoadingExistingElement() => detailsBloc.loadElement(_existingId);

    void whenLoadingNoneExistingElement() =>
        detailsBloc.loadElement(_noneExistingId);

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
        Success(_someData),
      ]);
    });

    tearDown(() {
      detailsBloc.close();
    });
  });

  group('failing repository', () {
    final _exception = Exception('Oh no!');
    final _error = Error();

    void givenFailingRepository(Object error) =>
        detailsBloc = DetailsBloc(FailingDetailsRepository(error));

    void whenLoadingElement() => detailsBloc.loadElement(0);

    test('should emit [$Loading, $Failure] when fetching element fails', () {
      givenFailingRepository(_exception);
      whenLoadingElement();
      thenExpectStates([
        const Loading(),
        Failure(_exception),
      ]);
    });

    test('should emit [$Loading, $Failure] when an error is thrown', () {
      givenFailingRepository(_error);
      whenLoadingElement();
      thenExpectStates([
        const Loading(),
        Failure(_error),
      ]);
    });

    tearDown(() {
      detailsBloc.close();
    });
  });
}
