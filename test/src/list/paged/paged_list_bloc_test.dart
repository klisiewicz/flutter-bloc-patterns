import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:flutter_bloc_patterns/src/common/view_state.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list.dart';
import 'package:flutter_test/flutter_test.dart';

import 'paged_repository_mock.dart';

void main() {
  const pageSize = 3;
  final firstPage = [0, 1, 2];
  final secondPage = [3, 4, 5];
  final thirdPage = [6];
  final someData = firstPage + secondPage + thirdPage;

  PagedListBloc<int> pagedListBloc;
  PagedRepository<int> pagedRepository;

  void whenLoadingFirstPage() =>
      pagedListBloc.loadFirstPage(pageSize: pageSize);

  void whenLoadingNextPage() => pagedListBloc.loadNextPage();

  Future<void> thenExpectStates(Iterable<ViewState> states) => expectLater(
        pagedListBloc.state,
        emitsInOrder(states),
      );

  group('repository without elements', () {
    setUp(() {
      pagedRepository = InMemoryPagedRepository<int>([]);
      pagedListBloc = PagedListBloc<int>(pagedRepository);
    });

    test('should emit list loaded empty when first page contains no elements',
        () {
      whenLoadingFirstPage();

      thenExpectStates([
        Initial(),
        Loading(),
        Empty(),
      ]);
    });
  });

  group('repository with elements', () {
    setUp(() {
      pagedRepository = InMemoryPagedRepository<int>(someData);
      pagedListBloc = PagedListBloc<int>(pagedRepository);
    });

    test(
        'should emit list loaded with first page elements when loading first page',
        () {
      whenLoadingFirstPage();

      thenExpectStates([
        Initial(),
        Loading(),
        Success(PagedList(firstPage, hasReachedMax: false)),
      ]);
    });

    test(
        'should emit list loaded with first, first and second page elements when loading two pages',
        () {
      whenLoadingFirstPage();
      whenLoadingNextPage();

      thenExpectStates([
        Initial(),
        Loading(),
        Success(PagedList(firstPage, hasReachedMax: false)),
        Success(PagedList(firstPage + secondPage, hasReachedMax: false)),
      ]);
    });

    test(
        'should emit list loaded with first, first and second and first, second and third page elements when loading three pages',
        () {
      whenLoadingFirstPage();
      whenLoadingNextPage();
      whenLoadingNextPage();

      thenExpectStates([
        Initial(),
        Loading(),
        Success(PagedList(firstPage, hasReachedMax: false)),
        Success(PagedList(firstPage + secondPage, hasReachedMax: false)),
        Success(PagedList(
          firstPage + secondPage + thirdPage,
          hasReachedMax: false,
        )),
      ]);
    });

    test(
        'should emit list loaded with hasReachedMax when there are no more pages',
        () {
      whenLoadingFirstPage();
      whenLoadingNextPage();
      whenLoadingNextPage();
      whenLoadingNextPage();

      thenExpectStates([
        Initial(),
        Loading(),
        Success(PagedList(firstPage, hasReachedMax: false)),
        Success(PagedList(firstPage + secondPage, hasReachedMax: false)),
        Success(PagedList(
          firstPage + secondPage + thirdPage,
          hasReachedMax: false,
        )),
        Success(PagedList(
          firstPage + secondPage + thirdPage,
          hasReachedMax: true,
        )),
      ]);
    });
  });

  group('failing repository', () {
    group('repository failing with exception', () {
      final exception = Exception('Ooopsi!');
      setUp(() {
        pagedRepository = FailingPagedRepository(exception);
        pagedListBloc = PagedListBloc<int>(pagedRepository);
      });

      test('should emit list not loaded when exception occurs', () {
        whenLoadingFirstPage();

        thenExpectStates([
          Initial(),
          Loading(),
          Failure(exception),
        ]);
      });
    });

    group('repository failing with error', () {
      final error = AssertionError();
      setUp(() {
        pagedRepository = FailingPagedRepository(error);
        pagedListBloc = PagedListBloc<int>(pagedRepository);
      });

      test('should emit list not loaded when error occurs', () {
        whenLoadingFirstPage();

        thenExpectStates([
          Initial(),
          Loading(),
          Failure(error),
        ]);
      });
    });

    group('repository failing with error', () {
      final pageNotFound = PageNotFoundException(0);
      setUp(() {
        pagedRepository = FailingPagedRepository(pageNotFound);
        pagedListBloc = PagedListBloc<int>(pagedRepository);
      });

      test('should emit list loaded empty when first page was not found', () {
        whenLoadingFirstPage();
        thenExpectStates([
          Initial(),
          Loading(),
          Empty(),
        ]);
      });
    });
  });
}
