import 'package:flutter_bloc_patterns/src/list/filter/filter_list_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'filter_list_repository_mock.dart';

void main() {
  const _someData = [1, 2, 3];
  const _notMatchingFilter = 0;
  const _matchingFilter = 1;
  const _matchingElements = [1];

  FilterListBloc<int, int> bloc;

  void whenLoadingElements({int filter}) => bloc.loadElements(filter: filter);

  void whenRefreshingElements({int filter}) =>
      bloc.refreshElements(filter: filter);

  Future<void> thenExpectStates(Iterable<ViewState> states) => expectLater(
        bloc,
        emitsInOrder(states),
      );

  group('empty repository', () {
    setUp(() {
      bloc = FilterListBloc(InMemoryFilterRepository());
    });

    test('should emit list loaded empty state when no filter is set', () {
      whenLoadingElements();
      thenExpectStates(const [
        Initial(),
        Loading(),
        Empty(),
      ]);
    });

    test('should emit list loaded empty state when filter is set', () {
      whenLoadingElements(filter: _notMatchingFilter);
      thenExpectStates(const [
        Initial(),
        Loading(),
        Empty(),
      ]);
    });

    tearDown(() {
      bloc.close();
    });
  });

  group('repository with elements', () {
    setUp(() {
      bloc = FilterListBloc(
        InMemoryFilterRepository(_someData),
      );
    });

    test(
        'should emit list loaded state with all elements when no filter is set',
        () {
      whenLoadingElements();
      thenExpectStates(const [
        Initial(),
        Loading(),
        Success(_someData),
      ]);
    });

    test('should emit list loaded state with elements matching the filter', () {
      whenLoadingElements(filter: _matchingFilter);
      thenExpectStates(const [
        Initial(),
        Loading(),
        Success(_matchingElements),
      ]);
    });

    test('should emit loaded empty list when no elements matches the filter',
        () {
      whenLoadingElements(filter: _notMatchingFilter);
      thenExpectStates(const [
        Initial(),
        Loading(),
        Empty(),
      ]);
    });

    test('should emit list loaded when refreshing with matching filter', () {
      whenLoadingElements(filter: _notMatchingFilter);
      whenRefreshingElements(filter: _matchingFilter);

      thenExpectStates(const [
        Initial(),
        Loading(),
        Empty(),
        Refreshing<List<int>>([]),
        Success<List<int>>(_matchingElements),
      ]);
    });

    test('should include loaded elements when refreshing', () {
      whenLoadingElements(filter: _matchingFilter);
      whenRefreshingElements(filter: _notMatchingFilter);

      thenExpectStates(const [
        Initial(),
        Loading(),
        Success(_matchingElements),
        Refreshing(_matchingElements),
        Empty(),
      ]);
    });

    tearDown(() {
      bloc.close();
    });
  });

  group('failing repository with exception', () {
    final exception = Exception('Oh no, I failed!');

    setUp(() {
      bloc = FilterListBloc(FailingFilterRepository(exception));
    });

    test('should emit list not loaded when no filter is set', () {
      whenLoadingElements();

      thenExpectStates([
        const Initial(),
        const Loading(),
        Failure(exception),
      ]);
    });

    test('should emit list not loaded when filter is set', () {
      whenLoadingElements(filter: _notMatchingFilter);

      thenExpectStates([
        const Initial(),
        const Loading(),
        Failure(exception),
      ]);
    });

    tearDown(() {
      bloc.close();
    });
  });

  group('failing repository with error', () {
    final error = Error();

    setUp(() {
      bloc = FilterListBloc(FailingFilterRepository(error));
    });

    test('should emit list error when error occurs', () {
      whenLoadingElements();
      thenExpectStates([
        const Initial(),
        const Loading(),
        Failure(error),
      ]);
    });

    tearDown(() {
      bloc.close();
    });
  });
}
