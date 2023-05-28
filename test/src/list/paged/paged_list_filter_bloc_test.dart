import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_filter_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_filter_repository.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/bdd.dart';
import '../../util/bloc_state_assertion.dart';
import 'paged_list_filter_repository_mock.dart';

// ignore_for_file: avoid_redundant_argument_values
void main() {
  const filter = 1;
  const pageSize = 3;

  late PagedListFilterBloc<int, int> bloc;
  late PagedListFilterRepository<int, int> repository;

  void loadingFirstPage({
    required int filter,
  }) {
    bloc.loadFirstPage(pageSize: pageSize, filter: filter);
  }

  void loadingNextPage() => bloc.loadNextPage();

  group('repository without items', () {
    setUp(() {
      repository = InMemoryPagedListFilterRepository<int, int>([]);
      bloc = PagedListFilterBloc<int, int>(repository);
    });

    test(
        'should emit [Loading, Empty] '
        'when first page contains no items', () {
      when(() => loadingFirstPage(filter: filter));
      then(() {
        withBloc(bloc).expectStates(
          const [Loading(), Empty()],
        );
      });
    });

    tearDown(() {
      bloc.close();
    });
  });

  group('repository with items', () {
    const items = [1, 1, 0, 1, 2, 3, 1, 1, 0];
    final firstPage = List<int>.generate(3, (i) => filter);
    final secondPage = List<int>.generate(2, (i) => filter);

    setUp(() {
      repository = InMemoryPagedListFilterRepository<int, int>(items);
      bloc = PagedListFilterBloc<int, int>(repository);
    });

    test(
        'should emit [Loading, Success] with items matching the filter '
        'when loading first page', () {
      when(() => loadingFirstPage(filter: filter));

      then(() {
        withBloc(bloc).expectStates([
          const Loading(),
          Success(PagedList(firstPage, hasReachedMax: false)),
        ]);
      });
    });

    test(
        'should emit [Loading, Success, Success] with '
        'first, '
        'first and second page items matching filter '
        'when loading two pages', () {
      when(() {
        loadingFirstPage(filter: filter);
        loadingNextPage();
      });

      then(() {
        withBloc(bloc).expectStates([
          const Loading(),
          Success(PagedList(firstPage, hasReachedMax: false)),
          Success(PagedList(firstPage + secondPage, hasReachedMax: true)),
        ]);
      });
    });

    tearDown(() {
      bloc.close();
    });
  });

  group('failing repository', () {
    group('repository failing with error', () {
      final error = AssertionError();

      setUp(() {
        repository = FailingPagedListFilterRepository(error);
        bloc = PagedListFilterBloc<int, int>(repository);
      });

      test(
          'should emit [Loading, Failure] '
          'when error occurs', () {
        when(() => loadingFirstPage(filter: 1));

        then(() {
          withBloc(bloc).expectStates([
            const Loading(),
            Failure(error),
          ]);
        });
      });

      tearDown(() {
        bloc.close();
      });
    });

    group('repository unable to find page', () {
      const pageNotFound = PageNotFoundException(0);

      setUp(() {
        repository = FailingPagedListFilterRepository(pageNotFound);
        bloc = PagedListFilterBloc<int, int>(repository);
      });

      test(
          'should emit [$Loading, $Empty] '
          'when first page was not found', () {
        when(() => loadingFirstPage(filter: filter));
        then(() {
          withBloc(bloc).expectStates(
            const [Loading(), Empty()],
          );
        });
      });

      tearDown(() {
        bloc.close();
      });
    });
  });
}
