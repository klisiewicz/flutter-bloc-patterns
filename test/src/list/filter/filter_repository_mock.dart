import 'package:flutter_bloc_patterns/src/list/filter/filter_list_repository.dart';

class InMemoryFilterRepository<T, F> extends FilterRepository<T, F> {
  final List<T> elements;

  InMemoryFilterRepository([this.elements = const []]);

  @override
  Future<List<T>> getAll() async => elements;

  @override
  Future<List<T>> getBy(F filter) async =>
      elements.where((item) => item == filter).toList();
}

final exception = Exception('I\'ve failed my lord...');

class FailingFilterRepository<T, F> extends FilterRepository<T, F> {
  @override
  Future<List<T>> getAll() async => throw exception;

  @override
  Future<List<T>> getBy(F filter) async => throw exception;
}
