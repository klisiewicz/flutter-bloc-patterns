import 'package:flutter_bloc_patterns/src/list/base/list_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_repository.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as m;

import '../../util/bdd.dart';
import '../../util/bloc_state_assertion.dart';
import 'list_repository_mock.dart';

void main() {
  ListBloc<int> bloc;
  ListRepository<int> repository;

  setUp(() {
    repository = ListRepositoryMock<int>();
    bloc = ListBloc(repository);
  });

  void emptyRepository() =>
      m.when(repository.getAll).thenAnswer((_) async => []);

  void repositoryWithElements() =>
      m.when(repository.getAll).thenAnswer((_) async => _someData);

  void failingRepository() => m.when(repository.getAll).thenThrow(_exception);

  void loadingElements() => bloc.loadElements();

  void refreshingElements() => bloc.refreshElements();

  test('should be initialized in initial state', () {
    expect(bloc.state, equals(const Initial()));
  });

  group('loading elements', () {
    test('should emit [$Loading, $Empty] when there is no data', () {
      given(emptyRepository);
      when(loadingElements);
      then(() => withBloc(bloc).expectStates(const [Loading(), Empty()]));
    });

    test('should emit [$Loading, $Success] when loading data is successful',
        () {
      given(repositoryWithElements);
      when(loadingElements);
      then(() =>
          withBloc(bloc).expectStates(const [Loading(), Success(_someData)]));
    });

    test('should emit [$Loading, $Failure(error)] when loading data fails', () {
      given(failingRepository);
      when(loadingElements);
      then(() =>
          withBloc(bloc).expectStates([const Loading(), Failure(_exception)]));
    });
  });

  group('refreshing elements', () {
    test(
        'should emit [$Loading, $Success, $Refreshing, $Success] when loading and refreshing is succeeds',
        () {
      given(repositoryWithElements);

      when(loadingElements);
      when(refreshingElements);

      then(
        () => withBloc(bloc).expectStates(const [
          Loading(),
          Success(_someData),
          Refreshing(_someData),
          Success(_someData),
        ]),
      );
    });
  });

  tearDown(() {
    bloc.close();
  });
}

final _exception = Exception("I've failed my lord...");
const _someData = [1, 2, 3];
