import 'dart:math';

import 'package:flutter_bloc_patterns/page.dart';
import 'package:flutter_bloc_patterns/paged_list.dart';

class InMemoryPagedListRepository<T> implements PagedListRepository<T> {
  final List<T> elements;

  InMemoryPagedListRepository(this.elements);

  @override
  Future<List<T>> getAll(Page page) async {
    if (elements.isEmpty) return [];
    if (page.offset >= elements.length) return [];

    final pageElements = elements.sublist(
      page.offset,
      min(page.offset + page.size, elements.length),
    );
    return pageElements;
  }
}

class FailingPagedRepository<T> implements PagedListRepository<T> {
  final dynamic error;

  FailingPagedRepository(this.error);

  @override
  Future<List<T>> getAll(Page page) => throw error;
}
