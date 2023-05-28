import 'package:flutter_bloc_patterns/src/list/base/list_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_repository.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as m;

import '../../util/bdd.dart';
import '../../util/bloc_state_assertion.dart';
import '../../util/mocktail_ext.dart';
import 'list_repository_mock.dart';

void main() {
  late ListBloc<int> bloc;
  late ListRepository<int> repository;

  setUp(() {
    repository = ListRepositoryMock<int>();
    bloc = ListBloc(repository);
  });

  void emptyRepository() => m.when(repository.getAll).thenAnswerFutureValue([]);

  void repositoryWithItems() =>
      m.when(repository.getAll).thenAnswerFutureValue(_someData);

  void failingRepository() => m.when(repository.getAll).thenThrow(_exception);

  void loadingItems() => bloc.loadItems();

  void refreshingItems() => bloc.refreshItems();

  test('should be initialized in initial state', () {
    expect(bloc.state, equals(const Initial<List<int>>()));
  });

  group('loading items', () {
    test(
        'should emit [Loading, Empty] '
        'when there is no data', () async {
      given(emptyRepository);
      when(loadingItems);
      then(() {
        withBloc(bloc).expectStates(
          const [Loading(), Empty()],
        );
      });
    });

    test(
        'should emit [Loading, Success] '
        'when loading data is successful', () async {
      given(repositoryWithItems);
      when(loadingItems);
      then(() {
        withBloc(bloc).expectStates(
          const [Loading(), Success(_someData)],
        );
      });
    });

    test(
        'should emit [Loading, Failure] '
        'when loading data fails', () async {
      given(failingRepository);
      when(loadingItems);
      then(() {
        withBloc(bloc).expectStates(
          [const Loading(), Failure(_exception)],
        );
      });
    });
  });

  group('refreshing items', () {
    test(
        'should emit [Loading, Success, Refreshing, Success] '
        'when loading and refreshing is succeeds', () async {
      given(repositoryWithItems);
      when(loadingItems);
      await then(() async {
        await withBloc(bloc).expectStates(
          const [Loading(), Success(_someData)],
        );
      });

      when(refreshingItems);
      await then(() async {
        await withBloc(bloc).expectStates(
          const [Refreshing(_someData), Success(_someData)],
        );
      });
    });
  });

  tearDown(() {
    bloc.close();
  });
}

final _exception = Exception("I've failed my lord...");
const _someData = [1, 2, 3];
