import 'package:flutter_bloc_patterns/src/list/filter/filter_list_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/bdd.dart';
import '../../util/bloc_state_assertion.dart';
import 'filter_list_repository_mock.dart';

void main() {
  const _someData = [1, 2, 3];
  const _notMatchingFilter = 0;
  const _matchingFilter = 1;
  const _matchingElements = [1];

  FilterListBloc<int, int> bloc;

  void loadingElements({int filter}) => bloc.loadElements(filter: filter);

  void refreshingElements({int filter}) => bloc.refreshElements(filter: filter);

  group('empty repository', () {
    setUp(() {
      bloc = FilterListBloc(InMemoryFilterRepository());
    });

    test('should emit [$Loading, $Empty] state when no filter is set', () {
      when(() => loadingElements());
      then(() => withBloc(bloc).expectStates(const [Loading(), Empty()]));
    });

    test(
        'should emit[$Loading, $Empty] when filter that matches no elements is set',
        () {
      when(() => loadingElements(filter: _notMatchingFilter));
      then(() => withBloc(bloc).expectStates(const [Loading(), Empty()]));
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
        'should emit [$Loading, $Success] with all elements when no filter is set',
        () {
      when(() => loadingElements());
      then(
        () =>
            withBloc(bloc).expectStates(const [Loading(), Success(_someData)]),
      );
    });

    test('should emit [$Loading, $Success] with elements matching the filter',
        () {
      when(() => loadingElements(filter: _matchingFilter));
      then(
        () => withBloc(bloc)
            .expectStates(const [Loading(), Success(_matchingElements)]),
      );
    });

    test('should emit [$Loading, $Empty] when no elements matches the filter',
        () {
      when(() => loadingElements(filter: _notMatchingFilter));
      then(
        () => withBloc(bloc).expectStates(const [Loading(), Empty()]),
      );
    });

    test(
        'should emit [$Loading, $Empty, $Refreshing, $Success] when refreshing with matching filter',
        () {
      when(() => loadingElements(filter: _notMatchingFilter));
      when(() => refreshingElements(filter: _matchingFilter));
      then(
        () => withBloc(bloc).expectStates(const [
          Loading(),
          Empty(),
          Refreshing<List<int>>([]),
          Success<List<int>>(_matchingElements),
        ]),
      );
    });

    test('should include loaded elements when refreshing', () {
      when(() => loadingElements(filter: _matchingFilter));
      when(() => refreshingElements(filter: _notMatchingFilter));

      then(
        () => withBloc(bloc).expectStates(const [
          Loading(),
          Success(_matchingElements),
          Refreshing(_matchingElements),
          Empty(),
        ]),
      );
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

    test('should emit [$Loading, $Failure] when no filter is set', () {
      when(() => loadingElements());
      then(
        () => withBloc(bloc).expectStates(
          [const Loading(), Failure(exception)],
        ),
      );
    });

    test('should emit [$Loading, $Failure] when filter is set', () {
      when(() => loadingElements(filter: _notMatchingFilter));
      then(
        () => withBloc(bloc).expectStates(
          [const Loading(), Failure(exception)],
        ),
      );
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

    test('should emit [$Loading, $Failure] when error occurs', () {
      when(() => loadingElements());
      then(
        () => withBloc(bloc).expectStates(
          [const Loading(), Failure(error)],
        ),
      );
    });

    tearDown(() {
      bloc.close();
    });
  });
}
