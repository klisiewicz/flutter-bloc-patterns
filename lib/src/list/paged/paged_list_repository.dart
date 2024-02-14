import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_patterns/src/list/paged/page.dart';

/// [PagedListRepository] allows to retrieve items using the pagination.
///
/// [T] - the type of returned items.
abstract interface class PagedListRepository<T> {
  /// Retrieves items meeting the pagination restriction provided by
  /// the [page] object.
  /// When items are exceeded should return an empty list or throw
  /// the [PageNotFoundException].
  Future<List<T>> getAll(Page page);
}

/// Exception thrown when page with given number doesn't exist.
@immutable
final class PageNotFoundException implements Exception {
  /// The page number that wasn't found.
  final int pageNumber;

  const PageNotFoundException(this.pageNumber);

  @override
  String toString() {
    return 'PageNotFoundException: $pageNumber page does not exist.';
  }
}
