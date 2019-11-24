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

// Exception thrown when page with given number doesn't exist.
class PageNotFoundException implements Exception {
  final pageNumber;

  PageNotFoundException(this.pageNumber);

  @override
  String toString() =>
      'PageNotFoundException: $pageNumber page does not exist.';
}
