import 'package:flutter_bloc_patterns/src/list/filter/filter_repository.dart';

class InMemoryFilterRepository<T, F> extends FilterRepository<T, F> {
  final List<T> items;

  InMemoryFilterRepository([this.items = const []]);

  @override
  Future<List<T>> getAll() async => items;

  @override
  Future<List<T>> getBy(F filter) async =>
      items.where((item) => item == filter).toList();
}

final exception = Exception('I\'ve failed my lord...');

class FailingFilterRepository<T, F> extends FilterRepository<T, F> {
  @override
  Future<List<T>> getAll() async => throw exception;

  @override
  Future<List<T>> getBy(F filter) async => throw exception;
}
