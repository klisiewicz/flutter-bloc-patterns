import 'package:flutter_bloc_patterns/src/list/base/list_states.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'filter_repository_mock.dart';

void main() {
  FilterListBloc<int, int> filterListBloc;

  void whenLoadingElements({int filter}) =>
      filterListBloc.loadElements(filter: filter);

  void whenRefreshingElements({int filter}) =>
      filterListBloc.refreshElements(filter: filter);

  Future<void> thenExpectStates(Iterable<ListState> states) =>
      expectLater(
        filterListBloc.state,
        emitsInOrder(states),
      );

  group('empty repository', () {
    setUp(() {
      filterListBloc = FilterListBloc(
        InMemoryFilterRepository(),
      );
    });

    test('should emit list loaded empty state when no filter is set', () {
      whenLoadingElements();
      thenExpectStates([
        ListLoading(),
        ListLoadedEmpty(),
      ]);
    });

    test('should emit list loaded empty state when filter is set', () {
      whenLoadingElements(filter: _notMatchingFilter);
      thenExpectStates([
        ListLoading(),
        ListLoadedEmpty(),
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
        ListLoading(),
        ListLoaded<int>(_someData),
      ]);
    });

    test('should emit list loaded state with elements matching the filter', () {
      whenLoadingElements(filter: _matchingFilter);
      thenExpectStates([
        ListLoading(),
        ListLoaded<int>(_matchingElements),
      ]);
    });

    test('should emit loaded empty list when no elements matches the filter',
            () {
      whenLoadingElements(filter: _notMatchingFilter);
      thenExpectStates([
        ListLoading(),
        ListLoadedEmpty(),
      ]);
    });

    test('should emit list loaded when refreshing with matching filter', () {
      whenLoadingElements(filter: _notMatchingFilter);
      whenRefreshingElements(filter: _matchingFilter);

      thenExpectStates([
        ListLoading(),
        ListLoadedEmpty(),
        ListRefreshing<int>(),
        ListLoaded<int>(_matchingElements),
      ]);
    });

    test('should include loaded elements when refreshing', () {
      whenLoadingElements(filter: _matchingFilter);
      whenRefreshingElements(filter: _notMatchingFilter);

      thenExpectStates([
        ListLoading(),
        ListLoaded<int>(_matchingElements),
        ListRefreshing<int>(_matchingElements),
        ListLoadedEmpty(),
      ]);
    });
  });

  group('failing repository', () {
    setUp(() {
      filterListBloc = FilterListBloc(
        FailingFilterRepository(),
      );
    });

    test('should emit list not loaded when no filter is set', () {
      whenLoadingElements();
      thenExpectStates([
        ListLoading(),
        ListNotLoaded(exception),
      ]);
    });

    test('should emit list not loaded when filter is set', () {
      whenLoadingElements(filter: _notMatchingFilter);
      thenExpectStates([
        ListLoading(),
        ListNotLoaded(exception),
      ]);
    });
  });
}

final _notMatchingFilter = 0;
final _matchingFilter = _someData[0];
final _matchingElements = [_someData[0]];
final _someData = [1, 2, 3];
