import 'package:flutter_bloc_patterns/details.dart';
import 'package:flutter_bloc_patterns/src/common/view_state.dart';
import 'package:flutter_bloc_patterns/src/details/details_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'details_repository_mock.dart';

void main() {
  DetailsBloc<String, int> detailsBloc;

  Future<void> thenExpectStates(Iterable<ViewState> states) async => expect(
        detailsBloc,
        emitsInOrder(states),
      );

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

    test('should be initialized in initial state', () {
      thenExpectStates([Initial()]);
    });

    test('should emit details not found when theres no element with given id',
        () {
      whenLoadingNoneExistingElement();
      thenExpectStates([
        Initial(),
        Loading(),
        Empty(),
      ]);
    });

    test('should emit details loaded when there is an element with given id',
        () {
      whenLoadingExistingElement();
      thenExpectStates([
        Initial(),
        Loading(),
        const Success(_someData),
      ]);
    });

    tearDown(() {
      detailsBloc.close();
    });
  });

  group('failing repository', () {
    final _exception = Exception('Oh no!');
    final _error = Error();

    void givenFailingRepository(error) =>
        detailsBloc = DetailsBloc(FailingDetailsRepository(error));

    void whenLoadingElement() => detailsBloc.loadElement(0);

    test('should emit details not loaded when fetching element fails', () {
      givenFailingRepository(_exception);
      whenLoadingElement();
      thenExpectStates([
        Initial(),
        Loading(),
        Failure(_exception),
      ]);
    });

    test(
        'should emit details not found when element not found exception is thrown',
        () {
      givenFailingRepository(ElementNotFoundException(0));
      whenLoadingElement();
      thenExpectStates([
        Initial(),
        Loading(),
        Empty(),
      ]);
    });

    test('should emit details error when an error is thrown', () {
      givenFailingRepository(_error);
      whenLoadingElement();
      thenExpectStates([
        Initial(),
        Loading(),
        Failure(_error),
      ]);
    });

    tearDown(() {
      detailsBloc.close();
    });
  });
}
