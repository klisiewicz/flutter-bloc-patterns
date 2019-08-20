import 'package:flutter_bloc_patterns/src/list/base/list_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_repository.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_states.dart';
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

  void givenRepositoryWithElements() =>
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

  group('loading elements', () {
    void whenLoadingElements() => listBloc.loadElements();

    test('should emit loaded empty list when there is no data', () {
      givenEmptyRepository();
      whenLoadingElements();
      thenExpectStates([ListLoading(), ListLoadedEmpty()]);
    });

    test('should emit list loaded state when loading data is successful', () {
      givenRepositoryWithElements();
      whenLoadingElements();
      thenExpectStates([
        ListLoading(),
        ListLoaded(_someData),
      ]);
    });

    test('should emit list not loaded when loading data fails', () {
      givenFailingRepository();
      whenLoadingElements();
      thenExpectStates([
        ListLoading(),
        ListNotLoaded(exception),
      ]);
    });
  });

  group('refreshing elements', () {
    void whenLoadingElements() => listBloc.loadElements();
    void whenRefreshingElements() => listBloc.refreshElements();

    test('should refresh elements when loading is finished', () {
      givenRepositoryWithElements();

      whenLoadingElements();
      whenRefreshingElements();

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
