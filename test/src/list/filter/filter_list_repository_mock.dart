import 'package:flutter_bloc_patterns/src/list/filter/filter_list_repository.dart';

const _delay = Duration.zero;

class InMemoryFilterRepository<T, F> implements FilterListRepository<T, F> {
  List<T> items;

  InMemoryFilterRepository([
    this.items = const [],
  ]);

  @override
  Future<List<T>> getAll() async => Future.delayed(_delay, () => items);

  @override
  Future<List<T>> getBy(F? filter) {
    return Future.delayed(
      _delay,
      () => items.where((item) => item == filter).toList(),
    );
  }
}

class FailingFilterRepository<T, F> implements FilterListRepository<T, F> {
  final Object _error;

  FailingFilterRepository(Object error) : _error = error;

  @override
  Future<List<T>> getAll() => Future.delayed(_delay, () => throw _error);

  @override
  Future<List<T>> getBy(F? filter) =>
      Future.delayed(_delay, () => throw _error);
}
