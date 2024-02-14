import 'dart:math';
import 'package:flutter_bloc_patterns/paged_list.dart';

class InMemoryPagedListRepository<T> implements PagedListRepository<T> {
  final List<T> items;

  InMemoryPagedListRepository([
    this.items = const [],
  ]);

  @override
  Future<List<T>> getAll(Page page) async {
    if (items.isEmpty) return [];
    if (page.offset >= items.length) return [];
    return items.sublist(
      page.offset,
      min(page.offset + page.size, items.length),
    );
  }
}

class FailingPagedRepository<T> implements PagedListRepository<T> {
  final Object error;

  FailingPagedRepository(this.error);

  @override
  Future<List<T>> getAll(Page page) => throw error;
}
