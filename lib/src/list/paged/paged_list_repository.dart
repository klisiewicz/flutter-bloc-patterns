import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_patterns/src/list/paged/page.dart';

/// [PagedListRepository] allows to retrieve elements using the pagination.
///
/// [T] - the type of returned elements.
abstract class PagedListRepository<T> {
  /// Retrieves elements meeting the pagination restriction provided by
  /// the [page] object.
  /// When elements are exceeded should return an empty list or throw
  /// the [PageNotFoundException].
  Future<List<T>> getAll(Page page);
}

/// Exception thrown when page with given number doesn't exist.
@immutable
class PageNotFoundException implements Exception {
  /// The page number that wasn't found.
  final int pageNumber;

  const PageNotFoundException(this.pageNumber);

  @override
  String toString() =>
      'PageNotFoundException: $pageNumber page does not exist.';
}
