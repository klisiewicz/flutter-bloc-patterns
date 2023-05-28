import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/bdd.dart';
import '../../util/bloc_state_assertion.dart';
import 'paged_list_repository_mock.dart';

// ignore_for_file: avoid_redundant_argument_values
void main() {
  late PagedListBloc<int> bloc;
  late PagedListRepository<int> repository;

  void loadingFirstPage() => bloc.loadFirstPage(pageSize: 3);

  void loadingNextPage() => bloc.loadNextPage();

  group('repository without items', () {
    setUp(() {
      repository = InMemoryPagedListRepository<int>([]);
      bloc = PagedListBloc<int>(repository);
    });

    test(
        'should emit [Loading, Empty] '
        'when first page contains no items', () {
      when(loadingFirstPage);
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
    const firstPage = [0, 1, 2];
    const secondPage = [3, 4, 5];
    const thirdPage = [6];
    final someData = firstPage + secondPage + thirdPage;

    setUp(() {
      repository = InMemoryPagedListRepository<int>(someData);
      bloc = PagedListBloc<int>(repository);
    });

    test(
        'should emit [Loading, Success] with '
        'first page items when loading first page', () {
      when(loadingFirstPage);

      then(() {
        withBloc(bloc).expectStates([
          const Loading(),
          Success(PagedList(firstPage, hasReachedMax: false)),
        ]);
      });
    });

    test(
        'should emit [Loading, Success, Success] with '
        'first,'
        'first and second page items '
        'when loading two pages', () {
      when(() {
        loadingFirstPage();
        loadingNextPage();
      });

      then(() {
        withBloc(bloc).expectStates([
          const Loading(),
          Success(PagedList(firstPage, hasReachedMax: false)),
          Success(PagedList(firstPage + secondPage, hasReachedMax: false)),
        ]);
      });
    });

    test(
        'should emit [Loading, Success, Success, Success] with '
        'first,'
        'first and second, '
        'first, second and third page items '
        'when loading three pages', () {
      when(() {
        loadingFirstPage();
        loadingNextPage();
        loadingNextPage();
      });

      then(() {
        withBloc(bloc).expectStates([
          const Loading(),
          Success(PagedList(firstPage, hasReachedMax: false)),
          Success(PagedList(firstPage + secondPage, hasReachedMax: false)),
          Success(
            PagedList(
              firstPage + secondPage + thirdPage,
              hasReachedMax: true,
            ),
          ),
        ]);
      });
    });

    test(
        'should emit  [Loading, Success, Success, Success] with hasReachedMax '
        'when there are no more pages', () {
      when(() {
        loadingFirstPage();
        loadingNextPage();
        loadingNextPage();
        loadingNextPage();
      });

      then(() {
        withBloc(bloc).expectStates([
          const Loading(),
          Success(PagedList(firstPage, hasReachedMax: false)),
          Success(PagedList(firstPage + secondPage, hasReachedMax: false)),
          Success(
            PagedList(
              firstPage + secondPage + thirdPage,
              hasReachedMax: true,
            ),
          ),
        ]);
      });
    });

    tearDown(() {
      bloc.close();
    });
  });

  group('failing repository', () {
    group('repository failing with exception', () {
      final exception = Exception('Oops!');
      setUp(() {
        repository = FailingPagedRepository(exception);
        bloc = PagedListBloc<int>(repository);
      });

      test(
          'should emit [Loading, Failure] '
          'when exception occurs', () {
        when(loadingFirstPage);
        then(() {
          withBloc(bloc).expectStates(
            [const Loading(), Failure(exception)],
          );
        });
      });

      tearDown(() {
        bloc.close();
      });
    });

    group('repository failing with error', () {
      final error = AssertionError();
      setUp(() {
        repository = FailingPagedRepository(error);
        bloc = PagedListBloc<int>(repository);
      });

      test(
          'should emit [Loading, Failure] '
          'when error occurs', () {
        when(loadingFirstPage);
        then(() {
          withBloc(bloc).expectStates(
            [const Loading(), Failure(error)],
          );
        });
      });

      tearDown(() {
        bloc.close();
      });
    });

    group('repository unable to find page', () {
      const pageNotFound = PageNotFoundException(0);
      setUp(() {
        repository = FailingPagedRepository(pageNotFound);
        bloc = PagedListBloc<int>(repository);
      });

      test(
          'should emit [Loading, Empty] '
          'when first page was not found', () {
        when(loadingFirstPage);
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
