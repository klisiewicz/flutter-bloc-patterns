import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/bloc_state_assertion.dart';
import 'paged_list_repository_mock.dart';

// ignore_for_file: avoid_redundant_argument_values
void main() {
  test('should emit [Loading, Empty] when first page contains no items',
      () async {
    final pagedListBloc = PagedListBloc(
      InMemoryPagedListRepository(<String>[]),
    );

    pagedListBloc.loadFirstPage(pageSize: 2);

    await withBloc(pagedListBloc).expectStates(const [
      Loading(),
      Empty(),
    ]);
  });

  test(
      'should emit [Loading, Data] with first page items when loading first page',
      () async {
    final pagedListBloc = PagedListBloc(
      InMemoryPagedListRepository(
        ['Hey', 'Hi', 'Hello', 'Word'],
      ),
    );

    pagedListBloc.loadFirstPage(pageSize: 2);

    await withBloc(pagedListBloc).expectStates([
      const Loading(),
      Data(PagedList(const ['Hey', 'Hi'], hasReachedMax: false)),
    ]);
  });

  test('should emit [Loading, Data, Data] when loading two pages', () async {
    final pagedListBloc = PagedListBloc(
      InMemoryPagedListRepository(
        ['Hey', 'Hi', 'Hello', 'Greetings', 'Word'],
      ),
    );

    pagedListBloc.loadFirstPage(pageSize: 2);
    pagedListBloc.loadNextPage();

    await withBloc(pagedListBloc).expectStates([
      const Loading(),
      Data(PagedList(const ['Hey', 'Hi'], hasReachedMax: false)),
      Data(
        PagedList(
          const ['Hey', 'Hi', 'Hello', 'Greetings'],
          hasReachedMax: false,
        ),
      ),
    ]);
  });

  test(
      'should emit [Loading, Data, Data, Data] with hasReachedMax when there are no more pages',
      () async {
    final pagedListBloc = PagedListBloc(
      InMemoryPagedListRepository(
        ['Hey', 'Hi', 'Hello', 'Greetings', 'Word'],
      ),
    );

    pagedListBloc.loadFirstPage(pageSize: 2);
    pagedListBloc.loadNextPage();
    pagedListBloc.loadNextPage();

    await withBloc(pagedListBloc).expectStates([
      const Loading(),
      Data(PagedList(const ['Hey', 'Hi'], hasReachedMax: false)),
      Data(
        PagedList(
          const ['Hey', 'Hi', 'Hello', 'Greetings'],
          hasReachedMax: false,
        ),
      ),
      Data(
        PagedList(
          const ['Hey', 'Hi', 'Hello', 'Greetings', 'Word'],
          hasReachedMax: true,
        ),
      ),
    ]);
  });

  test(
      'should emit [Loading, Data, Data] when loading more pages than available',
      () async {
    final pagedListBloc = PagedListBloc(
      InMemoryPagedListRepository(
        ['Hey', 'Hi', 'Hello'],
      ),
    );

    pagedListBloc.loadFirstPage(pageSize: 2);
    pagedListBloc.loadNextPage();
    pagedListBloc.loadNextPage();

    await withBloc(pagedListBloc).expectStates([
      const Loading(),
      Data(PagedList(const ['Hey', 'Hi'], hasReachedMax: false)),
      Data(PagedList(const ['Hey', 'Hi', 'Hello'], hasReachedMax: true)),
    ]);
  });

  test('should emit [Loading, Failure] when loading fails', () async {
    final exception = Exception('What the heck?');
    final pagedListBloc = PagedListBloc(
      FailingPagedRepository<String>(exception),
    );

    pagedListBloc.loadFirstPage(pageSize: 2);

    await withBloc(pagedListBloc).expectStates([
      const Loading(),
      Failure(exception),
    ]);
  });
}
