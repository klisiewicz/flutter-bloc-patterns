import 'package:flutter_bloc_patterns/src/list/base/list_repository.dart';

/// [FilterRepository] extends a [Repository] with filtering capabilities.
///
/// [F] - the filter type. It can be just a [String] for queries as well as
/// any object when filtering is more sophisticated.
/// [T] - the type of returned elements.
abstract class FilterRepository<T, F> extends Repository<T> {

  /// Retrieves elements matching the given [filter].
  Future<List<T>> getBy(F filter);
}
