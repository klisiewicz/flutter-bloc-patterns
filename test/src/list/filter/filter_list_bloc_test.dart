import 'package:flutter_bloc_patterns/src/list/base/list_states.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'filter_repository_mock.dart';

void main() {
  FilterListBloc<int, int> filterListBloc;

  void whenLoadingItems({int filter}) {
    filterListBloc.loadData(filter: filter);
  }

  void thenExpectStates(Iterable<ListState> states) {
    expectLater(
      filterListBloc.state,
      emitsInOrder(states),
    );
  }

  group('empty repository', () {
    setUp(() {
      filterListBloc = FilterListBloc(
        InMemoryFilterRepository(),
      );
    });

    test('should emit list loaded empty state when no filter is set', () {
      whenLoadingItems();
      thenExpectStates([ListLoading(), ListLoadedEmpty()]);
    });

    test('should emit list loaded empty state when filter is set', () {
      whenLoadingItems(filter: _notMatchingFilter);
      thenExpectStates([ListLoading(), ListLoadedEmpty()]);
    });
  });

  group('repository with items', () {
    setUp(() {
      filterListBloc = FilterListBloc(
        InMemoryFilterRepository(_someData),
      );
    });

    test('should emit list loaded state with all items when no filter is set',
        () {
      whenLoadingItems();
      thenExpectStates([ListLoading(), ListLoaded(_someData)]);
    });

    test('should emit list loaded state with items matching the filter', () {
      whenLoadingItems(filter: _matchingFilter);
      thenExpectStates([ListLoading(), ListLoaded(_matchingItems)]);
    });

    test('should emit loaded empty list when no item matches the filter', () {
      whenLoadingItems(filter: _notMatchingFilter);
      thenExpectStates([ListLoading(), ListLoadedEmpty()]);
    });
  });

  group('failing repository', () {
    setUp(() {
      filterListBloc = FilterListBloc(
        FailingFilterRepository(),
      );
    });

    test('should emit list not loaded when no filter is set', () {
      whenLoadingItems();
      thenExpectStates([
        ListLoading(),
        ListNotLoaded(exception),
      ]);
    });

    test('should emit list not loaded when filter is set', () {
      whenLoadingItems(filter: _notMatchingFilter);
      thenExpectStates([
        ListLoading(),
        ListNotLoaded(exception),
      ]);
    });
  });
}

final _notMatchingFilter = 0;
final _matchingFilter = _someData[0];
final _matchingItems = [_someData[0]];
final _someData = [1, 2, 3];
