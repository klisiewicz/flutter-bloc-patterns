import 'package:flutter_bloc_patterns/src/list/base/list_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_states.dart';
import 'package:flutter_bloc_patterns/src/list/base/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../filter/filter_repository_mock.dart';
import 'repository_mock.dart';

void main() {
  ListBloc<int> listBloc;
  Repository<int> repository;

  setUp(() {
    repository = RepositoryMock<int>();
    listBloc = ListBloc(repository);
  });

  void givenEmptyRepository() =>
      when(repository.getAll()).thenAnswer((_) async => []);

  void givenRepositoryWithItems() =>
      when(repository.getAll()).thenAnswer((_) async => _someData);

  void givenFailingRepository() =>
      when(repository.getAll()).thenThrow(exception);

  Future<void> thenExpectStates(Iterable<ListState> states) async =>
      expect(
        listBloc.state,
        emitsInOrder(states),
      );

  test('should be initialized in loading state', () {
    thenExpectStates([
      ListLoading(),
    ]);
  });

  group('loading items', () {
    void whenLoadingItems() => listBloc.loadItems();

    test('should emit loaded empty list when there is no data', () {
      givenEmptyRepository();
      whenLoadingItems();
      thenExpectStates([ListLoading(), ListLoadedEmpty()]);
    });

    test('should emit list loaded state when loading data is successful', () {
      givenRepositoryWithItems();
      whenLoadingItems();
      thenExpectStates([
        ListLoading(),
        ListLoaded(_someData),
      ]);
    });

    test('should emit list not loaded when loading data fails', () {
      givenFailingRepository();
      whenLoadingItems();
      thenExpectStates([
        ListLoading(),
        ListNotLoaded(exception),
      ]);
    });
  });

  group('refreshing items', () {
    void whenLoadingItems() => listBloc.loadItems();
    void whenRefreshingItems() => listBloc.refreshItems();

    test('should refresh items when loading is finished', () {
      givenRepositoryWithItems();

      whenLoadingItems();
      whenRefreshingItems();

      thenExpectStates([
        ListLoading(),
        ListLoaded(_someData),
        ListRefreshing(_someData),
        ListLoaded(_someData),
      ]);
    });
  });
}

final _someData = [1, 2, 3];
