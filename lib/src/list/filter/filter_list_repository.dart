import 'package:flutter_bloc_patterns/src/list/base/list_repository.dart';

/// [FilterListRepository] extends a [ListRepository] with filtering capabilities.
///
/// [T] - the type of returned items.
/// [F] - the filter type. It can be just a [String] for queries as well as
/// any object when filtering is more sophisticated.
abstract interface class FilterListRepository<T, F>
    implements ListRepository<T> {
  /// Retrieves items matching the given [filter].
  Future<List<T>> getBy(F filter);
}
