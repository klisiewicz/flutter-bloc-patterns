import 'package:flutter_bloc_patterns/details.dart';
import 'package:flutter_bloc_patterns/src/details/details_bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util/bloc_state_assertion.dart';
import 'details_repository_mock.dart';

void main() {
  test('should be initialized in Initial state', () {
    final detailsBloc = DetailsBloc(
      InMemoryDetailsRepository<String, int>(items: {}),
    );

    withBloc(detailsBloc).expectState(const Initial());
  });

  test('should emit [Loading, Data] when there is an element with given id',
      () {
    final detailsBloc = DetailsBloc(
      InMemoryDetailsRepository(items: {1: 'Hello'}),
    );

    detailsBloc.loadItem(1);

    withBloc(detailsBloc).expectStates(const [
      Loading(),
      Data('Hello'),
    ]);
  });

  test('should emit [Loading, Empty] when there is NO element with given id',
      () {
    final detailsBloc = DetailsBloc(
      InMemoryDetailsRepository(items: {1: 'Hello'}),
    );

    detailsBloc.loadItem(2);

    withBloc(detailsBloc).expectStates(const [
      Loading(),
      Empty(),
    ]);
  });

  test(
      'should emit [Loading, Failure] when loading elements fails with Exception',
      () {
    final exception = Exception('Oh no!');
    final detailsBloc = DetailsBloc(
      FailingDetailsRepository<String, int>(exception),
    );

    detailsBloc.loadItem(1);

    withBloc(detailsBloc).expectStates([
      const Loading(),
      Failure(exception),
    ]);
  });

  test('should emit [Loading, Failure] when loading elements fails with Error',
      () {
    final error = ArgumentError('Wrong arg');
    final detailsBloc = DetailsBloc(
      FailingDetailsRepository<String, int>(error),
    );

    detailsBloc.loadItem(1);

    withBloc(detailsBloc).expectStates([
      const Loading(),
      Failure(error),
    ]);
  });
}
