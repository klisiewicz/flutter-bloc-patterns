import 'package:flutter_bloc_patterns/src/common/state.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_repository.dart';
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

  void givenEmptyRepository() =>
      when(repository.getAll()).thenAnswer((_) async => []);

  void givenRepositoryWithElements() =>
      when(repository.getAll()).thenAnswer((_) async => _someData);

  void givenFailingRepository() =>
      when(repository.getAll()).thenThrow(_exception);

  Future<void> thenExpectStates(Iterable<State> states) async =>
      expect(
        listBloc.state,
        emitsInOrder(states),
      );

  test('should be initialized in loading state', () {
    thenExpectStates([
      Loading(),
    ]);
  });

  group('loading elements', () {
    void whenLoadingElements() => listBloc.loadElements();

    test('should emit loaded empty list when there is no data', () {
      givenEmptyRepository();
      whenLoadingElements();
      thenExpectStates([Loading(), Empty()]);
    });

    test('should emit list loaded state when loading data is successful', () {
      givenRepositoryWithElements();
      whenLoadingElements();
      thenExpectStates([
        Loading(),
        Success(_someData),
      ]);
    });

    test('should emit list not loaded when loading data fails', () {
      givenFailingRepository();
      whenLoadingElements();
      thenExpectStates([
        Loading(),
        Failure(_exception),
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
        Loading(),
        Success(_someData),
        Refreshing(_someData),
        Success(_someData),
      ]);
    });
  });
}

final _exception = Exception('I\'ve failed my lord...');
final _someData = [1, 2, 3];
