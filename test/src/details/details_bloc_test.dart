import 'package:flutter_bloc_patterns/details.dart';
import 'package:flutter_bloc_patterns/src/details/details_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util/bdd.dart';
import '../util/bloc_state_assertion.dart';
import 'details_repository_mock.dart';

void main() {
  late DetailsBloc<String, int> detailsBloc;

  group('repository with items', () {
    const existingId = 1;
    const noneExistingId = -1;
    const someData = 'Hello Word';

    setUp(() {
      detailsBloc = DetailsBloc(
        InMemoryDetailsRepository<String, int>({
          existingId: someData,
        }),
      );
    });

    void loadingExistingElement() => detailsBloc.loadItem(existingId);

    void loadingNoneExistingElement() => detailsBloc.loadItem(noneExistingId);

    test('should be initialized in Initial state', () {
      expect(detailsBloc.state, equals(const Initial<String>()));
    });

    test(
        'should emit [$Loading, $Empty] when there is no element with given id',
        () {
      when(loadingNoneExistingElement);
      then(() {
        withBloc(detailsBloc).expectStates(
          const [Loading(), Empty()],
        );
      });
    });

    test(
        'should emit [$Loading, $Success] when there is an element with given id',
        () {
      when(loadingExistingElement);
      then(() {
        withBloc(detailsBloc).expectStates(
          const [Loading(), Success(someData)],
        );
      });
    });

    tearDown(() {
      detailsBloc.close();
    });
  });

  group('failing repository', () {
    final exception = Exception('Oh no!');
    final error = Error();

    void failingRepository(Object error) =>
        detailsBloc = DetailsBloc(FailingDetailsRepository(error));

    void loadingElement() => detailsBloc.loadItem(0);

    test('should emit [$Loading, $Failure] when fetching element fails', () {
      given(() => failingRepository(exception));
      when(loadingElement);
      then(() {
        withBloc(detailsBloc).expectStates(
          [const Loading(), Failure(exception)],
        );
      });
    });

    test('should emit [$Loading, $Failure] when an error is thrown', () {
      given(() => failingRepository(error));
      when(loadingElement);
      then(() {
        withBloc(detailsBloc).expectStates(
          [const Loading(), Failure(error)],
        );
      });
    });

    tearDown(() {
      detailsBloc.close();
    });
  });
}
