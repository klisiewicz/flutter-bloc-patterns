import 'dart:math';

import 'package:flutter_bloc_patterns/page.dart';
import 'package:flutter_bloc_patterns/paged_list.dart';

class InMemoryPagedListRepository<T> implements PagedListRepository<T> {
  final List<T> elements;

  InMemoryPagedListRepository(this.elements);

  @override
  Future<Page<T>> getAll(Page<T> page) async {
    if (elements.isEmpty) return page.withElements(elements);
    if (page.offset >= elements.length) return page.withElements([]);

    final pageElements = elements.sublist(
      page.offset,
      min(page.offset + page.size, elements.length),
    );
    return page.withElements(pageElements);
  }
}

class FailingPagedRepository<T> implements PagedListRepository<T> {
  final dynamic error;

  FailingPagedRepository(this.error);

  @override
  Future<Page<T>> getAll(Page<T> page) => throw error;
}
