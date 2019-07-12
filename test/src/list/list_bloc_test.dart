import 'package:flutter_bloc_patterns/src/list/list_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/list_states.dart';
import 'package:flutter_bloc_patterns/src/list/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'repository_mock.dart';

void main() {
  ListBloc<int> listBloc;
  Repository<int> repository;

  setUp(() {
    repository = RepositoryMock<int>();
    listBloc = ListBloc(repository);
  });

  void thenExpectStates(Iterable<ListState> states) {
    expectLater(
      listBloc.state,
      emitsInOrder(states),
    );
  }

  test('should be initialized in loading state', () {
    thenExpectStates([
      ListLoading(),
    ]);
  });

  group('loading items', () {
    void givenEmptyRepository() =>
        when(repository.getAll()).thenAnswer((_) async => []);

    void givenRepositoryWithItems() =>
        when(repository.getAll()).thenAnswer((_) async => _someData);

    void givenFailingRepository() =>
        when(repository.getAll()).thenThrow(_someException);

    void whenLoadingItems() => listBloc.loadData();

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
        ListNotLoaded(_someException),
      ]);
    });
  });
}

final _someData = [1, 2, 3];
final _someException = Exception('I\'ve failed my lord...');
