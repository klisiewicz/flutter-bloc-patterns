import 'package:flutter_bloc_patterns/src/list/filter/filter_list_repository.dart';

class InMemoryFilterRepository<T, F> extends FilterListRepository<T, F> {
  final List<T> elements;

  InMemoryFilterRepository([this.elements = const []]);

  @override
  Future<List<T>> getAll() async => elements;

  @override
  Future<List<T>> getBy(F filter) async =>
      elements.where((item) => item == filter).toList();
}

class FailingFilterRepository<T, F> extends FilterListRepository<T, F> {
  final dynamic error;

  FailingFilterRepository(this.error);

  @override
  Future<List<T>> getAll() async => throw error;

  @override
  Future<List<T>> getBy(F filter) async => throw error;
}
