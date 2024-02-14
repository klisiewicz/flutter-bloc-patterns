import 'package:flutter_bloc_patterns/src/list/base/list_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/bloc_state_assertion.dart';
import '../filter/filter_list_repository_mock.dart';

void main() {
  test('should be initialized in initial state', () {
    final listBloc = ListBloc(
      InMemoryFilterRepository<String, String>(),
    );

    withBloc(listBloc).expectState(const Initial<List<String>>());
  });

  group('loading items', () {
    test('should emit [Loading, Empty] when there is no data', () async {
      final listBloc = ListBloc(
        InMemoryFilterRepository<String, String>(),
      );

      listBloc.loadItems();

      withBloc(listBloc).expectStates(const [
        Loading(),
        Empty(),
      ]);
    });

    test('should emit [Loading, Data] when loading succeeds', () async {
      final listBloc = ListBloc(
        InMemoryFilterRepository(['Hello']),
      );

      listBloc.loadItems();

      withBloc(listBloc).expectStates(const [
        Loading(),
        Data(['Hello']),
      ]);
    });

    test('should emit [Loading, Failure] when loading fails', () async {
      final exception = Exception('Ooopsi...');
      final listBloc = ListBloc(
        FailingFilterRepository(exception),
      );

      listBloc.loadItems();

      withBloc(listBloc).expectStates([
        const Loading(),
        Failure(exception),
      ]);
    });
  });

  group('refreshing items', () {
    test(
        'should emit [Loading, Data, Refreshing, Data] when loading and refreshing succeeds',
        () async {
      final repository = InMemoryFilterRepository(['Hello']);
      final listBloc = ListBloc(repository);

      listBloc.loadItems();

      await withBloc(listBloc).expectStates(const [
        Loading(),
        Data(['Hello']),
      ]);

      repository.items = ['Hello', 'Word'];

      listBloc.refreshItems();
      await withBloc(listBloc).expectStates(
        const [
          Refreshing(['Hello']),
          Data(['Hello', 'Word']),
        ],
      );
    });
  });
}
