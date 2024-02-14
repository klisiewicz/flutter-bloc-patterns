import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_filter_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/bloc_state_assertion.dart';
import 'paged_list_filter_repository_mock.dart';

// ignore_for_file: avoid_redundant_argument_values
void main() {
  test('should emit [Loading, Empty] when first page contains no items',
      () async {
    final pagedListFilterBloc = PagedListFilterBloc<String, String>(
      InMemoryPagedListFilterRepository(['Hello', 'Word']),
    );

    pagedListFilterBloc.loadFirstPage(pageSize: 2, filter: 'Hi');

    await withBloc(pagedListFilterBloc).expectStates(const [
      Loading(),
      Empty(),
    ]);
  });

  test('should emit [Loading, Data, Data] with when loading two pages', () {
    final pagedListFilterBloc = PagedListFilterBloc<String, String>(
      InMemoryPagedListFilterRepository(
        ['Hello', 'Word', 'Hi', 'Hello', 'Word', 'Hello'],
      ),
    );

    pagedListFilterBloc.loadFirstPage(pageSize: 2, filter: 'Hello');
    pagedListFilterBloc.loadNextPage();

    withBloc(pagedListFilterBloc).expectStates([
      const Loading(),
      Data(PagedList(const ['Hello', 'Hello'], hasReachedMax: false)),
      Data(
        PagedList(const ['Hello', 'Hello', 'Hello'], hasReachedMax: true),
      ),
    ]);
  });

  test('should emit [Loading, Data, Data, Data] with when loading three pages',
      () {
    final pagedListFilterBloc = PagedListFilterBloc<String, String>(
      InMemoryPagedListFilterRepository(
        ['Hello', 'Word', 'Hi', 'Hello', 'Word', 'Hello', 'Hi', 'Hello'],
      ),
    );

    pagedListFilterBloc.loadFirstPage(pageSize: 2, filter: 'Hello');
    pagedListFilterBloc.loadNextPage();
    pagedListFilterBloc.loadNextPage();

    withBloc(pagedListFilterBloc).expectStates([
      const Loading(),
      Data(PagedList(const ['Hello', 'Hello'], hasReachedMax: false)),
      Data(
        PagedList(
          const ['Hello', 'Hello', 'Hello', 'Hello'],
          hasReachedMax: false,
        ),
      ),
      Data(
        PagedList(
          const ['Hello', 'Hello', 'Hello', 'Hello'],
          hasReachedMax: true,
        ),
      ),
    ]);
  });

  test('should emit [Loading, Failure] when loading page fails', () async {
    final exception = Exception('What have I done...');
    final pagedListFilterBloc = PagedListFilterBloc<String, String>(
      FailingPagedListFilterRepository(exception),
    );

    pagedListFilterBloc.loadFirstPage(pageSize: 2, filter: 'Hi');
    await withBloc(pagedListFilterBloc).expectStates([
      const Loading(),
      Failure(exception),
    ]);
  });
}
