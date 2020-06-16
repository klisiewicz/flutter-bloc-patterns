import 'package:flutter_bloc_patterns/page.dart';
import 'package:flutter_bloc_patterns/paged_filter_list.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_filter_repository.dart';

import 'paged_list_repository_mock.dart';

class InMemoryPagedListFilterRepository<T, F>
    implements PagedListFilterRepository<T, F> {
  final List<T> elements;

  InMemoryPagedListFilterRepository(this.elements);

  @override
  Future<Page<T>> getAll(Page<T> page) => getBy(page, null);

  @override
  Future<Page<T>> getBy(Page<T> page, F filter) {
    final elementsMatchingFilter =
        elements.where((item) => item == filter).toList();
    return InMemoryPagedListRepository(elementsMatchingFilter).getAll(page);
  }
}

class FailingPagedListFilterRepository<T, F>
    implements PagedListFilterRepository<T, F> {
  final dynamic error;

  FailingPagedListFilterRepository(this.error);

  @override
  Future<Page<T>> getAll(Page<T> page) => throw error;

  @override
  Future<Page<T>> getBy(Page<T> page, F filter) => throw error;
}
