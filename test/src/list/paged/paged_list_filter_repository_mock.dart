import 'package:flutter_bloc_patterns/paged_filter_list.dart';

import 'paged_list_repository_mock.dart';

class InMemoryPagedListFilterRepository<T, F>
    implements PagedListFilterRepository<T, F> {
  final List<T> items;

  InMemoryPagedListFilterRepository(this.items);

  @override
  Future<List<T>> getAll(Page page) async {
    return InMemoryPagedListRepository(items).getAll(page);
  }

  @override
  Future<List<T>> getBy(Page page, F filter) {
    final itemsMatchingFilter = items.where((item) => item == filter).toList();
    return InMemoryPagedListRepository(itemsMatchingFilter).getAll(page);
  }
}

class FailingPagedListFilterRepository<T, F>
    implements PagedListFilterRepository<T, F> {
  final Object error;

  FailingPagedListFilterRepository(this.error);

  @override
  Future<List<T>> getAll(Page page) => Future.error(error);

  @override
  Future<List<T>> getBy(Page page, F filter) => Future.error(error);
}
