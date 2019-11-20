import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:flutter_bloc_patterns/src/list/paged/page.dart';

/// [PagedListFilterRepository] extends [PagedListRepository] with filtering
/// capabilities.
///
/// [T] - the type of returned elements.
/// [F] - the filter type. It can be just a [String] for queries as well as
/// any object when filtering is more sophisticated.
abstract class PagedListFilterRepository<T, F> extends PagedListRepository<T> {
  /// Retrieves elements meeting the [filter] as well as the
  /// pagination restriction provided by the [page] object and.
  /// When elements are exceeded should return an empty list or throw
  /// the [PageNotFoundException].
  Future<List<T>> getBy(Page page, F filter);
}
