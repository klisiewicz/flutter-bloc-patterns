import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:flutter_bloc_patterns/src/common/view_state.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_filter_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_filter_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/bdd.dart';
import '../../util/bloc_state_assertion.dart';
import 'paged_list_filter_repository_mock.dart';

void main() {
  const pageSize = 3;

  PagedListFilterBloc<int, int> bloc;
  PagedListFilterRepository<int, int> repository;

  void loadingFirstPage({int filter}) =>
      bloc.loadFirstPage(pageSize: pageSize, filter: filter);

  void loadingNextPage() => bloc.loadNextPage();

  group('repository without elements', () {
    setUp(() {
      repository = InMemoryPagedListFilterRepository<int, int>([]);
      bloc = PagedListFilterBloc<int, int>(repository);
    });

    test('should emit list loaded empty when first page contains no elements',
        () {
      when(loadingFirstPage);
      then(
        () => withBloc(bloc).expectStates([
          Initial(),
          Loading(),
          Empty(),
        ]),
      );
    });

    tearDown(() {
      bloc.close();
    });
  });

  group('repository with elements', () {
    const filter = 1;
    const elements = [1, 1, 0, 1, 2, 3, 1, 1, 0];
    final firstPage = List<int>.generate(3, (i) => filter);
    final secondPage = List<int>.generate(2, (i) => filter);

    setUp(() {
      repository = InMemoryPagedListFilterRepository<int, int>(elements);
      bloc = PagedListFilterBloc<int, int>(repository);
    });

    test(
        'should emit list loaded with elements matching the filter when loading first page',
        () {
      when(() {
        loadingFirstPage(filter: filter);
      });

      then(() {
        withBloc(bloc).expectStates([
          Initial(),
          Loading(),
          Success(PagedList(firstPage, hasReachedMax: false)),
        ]);
      });
    });

    test(
        'should emit list loaded with first, first and second page elements matching filter when loading two pages',
        () {
      when(() {
        loadingFirstPage(filter: filter);
        loadingNextPage();
      });

      then(() {
        withBloc(bloc).expectStates([
          Initial(),
          Loading(),
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

      test('should emit list not loaded when error occurs', () {
        when(loadingFirstPage);

        then(
          () => withBloc(bloc).expectStates([
            Initial(),
            Loading(),
            Failure(error),
          ]),
        );
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

      test('should emit list loaded empty when first page was not found', () {
        when(loadingFirstPage);
        then(
          () => withBloc(bloc).expectStates([
            Initial(),
            Loading(),
            Empty(),
          ]),
        );
      });

      tearDown(() {
        bloc.close();
      });
    });
  });
}
