import 'package:flutter_bloc_patterns/src/list/base/repository.dart';

/// [FilterRepository] extends a [Repository] with filtering capabilities.
///
/// [T] - the type of returned items.
/// [F] - the filter type. It can be just a [String] for queries as well as
/// any object when filtering is more sophisticated.
abstract class FilterRepository<T, F> extends Repository<T> {

  /// Retrieves items matching the given [filter].
  Future<List<T>> getBy(F filter);
}
