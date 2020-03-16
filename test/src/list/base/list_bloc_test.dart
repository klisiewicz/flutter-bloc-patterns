import 'package:flutter_bloc_patterns/src/common/view_state.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'list_repository_mock.dart';

void main() {
  ListBloc<int> bloc;
  ListRepository<int> repository;

  setUp(() {
    repository = ListRepositoryMock<int>();
    bloc = ListBloc(repository);
  });

  void givenEmptyRepository() =>
      when(repository.getAll()).thenAnswer((_) async => []);

  void givenRepositoryWithElements() =>
      when(repository.getAll()).thenAnswer((_) async => _someData);

  void givenFailingRepository() =>
      when(repository.getAll()).thenThrow(_exception);

  Future<void> thenExpectStates(Iterable<ViewState> states) async => expect(
        bloc,
        emitsInOrder(states),
      );

  test('should be initialized in initial state', () {
    thenExpectStates([
      const Initial(),
    ]);
  });

  group('loading elements', () {
    void whenLoadingElements() => bloc.loadElements();

    test('should emit loaded empty list when there is no data', () {
      givenEmptyRepository();
      whenLoadingElements();
      thenExpectStates(const [
        Initial(),
        Loading(),
        Empty(),
      ]);
    });

    test('should emit list loaded state when loading data is successful', () {
      givenRepositoryWithElements();
      whenLoadingElements();
      thenExpectStates(const [
        Initial(),
        Loading(),
        Success(_someData),
      ]);
    });

    test('should emit list not loaded when loading data fails', () {
      givenFailingRepository();
      whenLoadingElements();
      thenExpectStates([
        const Initial(),
        const Loading(),
        Failure(_exception),
      ]);
    });
  });

  group('refreshing elements', () {
    void whenLoadingElements() => bloc.loadElements();
    void whenRefreshingElements() => bloc.refreshElements();

    test('should refresh elements when loading is finished', () {
      givenRepositoryWithElements();

      whenLoadingElements();
      whenRefreshingElements();

      thenExpectStates(const [
        Initial(),
        Loading(),
        Success(_someData),
        Refreshing(_someData),
        Success(_someData),
      ]);
    });
  });

  tearDown(() {
    bloc.close();
  });
}

final _exception = Exception('I\'ve failed my lord...');
const _someData = [1, 2, 3];
