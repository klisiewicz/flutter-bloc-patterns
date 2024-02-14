import 'package:flutter_bloc_patterns/src/list/filter/filter_list_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/bloc_state_assertion.dart';
import 'filter_list_repository_mock.dart';

void main() {
  test('should emit [Loading, Data] with all items when no filter is set',
      () async {
    final filterListBloc = FilterListBloc<String, String>(
      InMemoryFilterRepository(['Hello', 'Word']),
    );

    filterListBloc.loadItems();

    await withBloc(filterListBloc).expectStates(const [
      Loading(),
      Data(['Hello', 'Word']),
    ]);
  });

  test('should emit [Loading, Data] with items matching the filter', () async {
    final filterListBloc = FilterListBloc<String, String>(
      InMemoryFilterRepository(['Hello', 'Word']),
    );

    filterListBloc.loadItems(filter: 'Hello');

    await withBloc(filterListBloc).expectStates(const [
      Loading(),
      Data(['Hello']),
    ]);
  });

  test('should emit [Loading, Empty] when no items matches the filter',
      () async {
    final filterListBloc = FilterListBloc<String, String>(
      InMemoryFilterRepository(['Hello', 'Word']),
    );

    filterListBloc.loadItems(filter: 'Hi');

    await withBloc(filterListBloc).expectStates(const [
      Loading(),
      Empty(),
    ]);
  });

  test(
      'should emit [Loading, Empty, Refreshing, Data] when refreshing with matching filter',
      () async {
    final filterListBloc = FilterListBloc(
      InMemoryFilterRepository<String, String>(['Hello', 'Word']),
    );

    filterListBloc.loadItems(filter: 'Hi');

    await withBloc(filterListBloc).expectStates(const [
      Loading(),
      Empty(),
    ]);

    filterListBloc.refreshItems(filter: 'Hello');

    await withBloc(filterListBloc).expectStates(const [
      Refreshing(<String>[]),
      Data(['Hello']),
    ]);
  });

  test('should include loaded items when refreshing', () async {
    final filterListBloc = FilterListBloc(
      InMemoryFilterRepository<String, String>(['Hello', 'Word']),
    );

    filterListBloc.loadItems(filter: 'Hello');

    await withBloc(filterListBloc).expectStates(const [
      Loading(),
      Data(['Hello']),
    ]);

    filterListBloc.refreshItems(filter: 'Hi');

    await withBloc(filterListBloc).expectStates(const [
      Refreshing(['Hello']),
      Empty(),
    ]);
  });

  test('should emit [Loading, Failure] when loading fails', () async {
    final exception = Exception('Holy crap!');
    final filterListBloc = FilterListBloc(
      FailingFilterRepository<String, String>(exception),
    );

    filterListBloc.loadItems();

    await withBloc(filterListBloc).expectStates([
      const Loading(),
      Failure(exception),
    ]);
  });
}
