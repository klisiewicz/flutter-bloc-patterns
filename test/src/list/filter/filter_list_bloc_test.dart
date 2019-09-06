import 'package:flutter_bloc_patterns/src/common/state.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'filter_repository_mock.dart';

void main() {
  final _someData = [1, 2, 3];
  final _notMatchingFilter = 0;
  final _matchingFilter = _someData[0];
  final _matchingElements = [_someData[0]];

  FilterListBloc<int, int> filterListBloc;

  void whenLoadingElements({int filter}) =>
      filterListBloc.loadElements(filter: filter);

  void whenRefreshingElements({int filter}) =>
      filterListBloc.refreshElements(filter: filter);

  Future<void> thenExpectStates(Iterable<State> states) =>
      expectLater(
        filterListBloc.state,
        emitsInOrder(states),
      );

  group('empty repository', () {
    setUp(() {
      filterListBloc = FilterListBloc(InMemoryFilterRepository());
    });

    test('should emit list loaded empty state when no filter is set', () {
      whenLoadingElements();
      thenExpectStates([
        Loading(),
        Empty(),
      ]);
    });

    test('should emit list loaded empty state when filter is set', () {
      whenLoadingElements(filter: _notMatchingFilter);
      thenExpectStates([
        Loading(),
        Empty(),
      ]);
    });
  });

  group('repository with elements', () {
    setUp(() {
      filterListBloc = FilterListBloc(
        InMemoryFilterRepository(_someData),
      );
    });

    test(
        'should emit list loaded state with all elements when no filter is set',
            () {
          whenLoadingElements();
          thenExpectStates([
            Loading(),
            Success(_someData),
          ]);
        });

    test('should emit list loaded state with elements matching the filter', () {
      whenLoadingElements(filter: _matchingFilter);
      thenExpectStates([
        Loading(),
        Success(_matchingElements),
      ]);
    });

    test('should emit loaded empty list when no elements matches the filter',
            () {
          whenLoadingElements(filter: _notMatchingFilter);
          thenExpectStates([
            Loading(),
            Empty(),
          ]);
        });

    test('should emit list loaded when refreshing with matching filter', () {
      whenLoadingElements(filter: _notMatchingFilter);
      whenRefreshingElements(filter: _matchingFilter);

      thenExpectStates([
        Loading(),
        Empty(),
        Refreshing<List<int>>([]),
        Success<List<int>>(_matchingElements),
      ]);
    });

    test('should include loaded elements when refreshing', () {
      whenLoadingElements(filter: _matchingFilter);
      whenRefreshingElements(filter: _notMatchingFilter);

      thenExpectStates([
        Loading(),
        Success(_matchingElements),
        Refreshing(_matchingElements),
        Empty(),
      ]);
    });
  });

  group('failing repository with exception', () {
    final exception = Exception('Oh no, I failed!');

    setUp(() {
      filterListBloc = FilterListBloc(FailingFilterRepository(exception));
    });

    test('should emit list not loaded when no filter is set', () {
      whenLoadingElements();
      thenExpectStates([
        Loading(),
        Failure(exception),
      ]);
    });

    test('should emit list not loaded when filter is set', () {
      whenLoadingElements(filter: _notMatchingFilter);
      thenExpectStates([
        Loading(),
        Failure(exception),
      ]);
    });
  });

  group('failing repository with error', () {
    final error = Error();

    setUp(() {
      filterListBloc = FilterListBloc(FailingFilterRepository(error));
    });

    test('should emit list error when error occurs', () {
      whenLoadingElements();
      thenExpectStates([
        Loading(),
        Failure(error),
      ]);
    });
  });
}
