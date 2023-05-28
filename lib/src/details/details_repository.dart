/// [DetailsRepository] allows to retrieve an item based on its id.
///
/// [T] - the element type.
/// [I] - the element's id type.
abstract interface class DetailsRepository<T, I> {
  /// Retrieves an element with given id. When there's no element matching the
  /// given [id] `null` should be returned.
  Future<T?> getById(I id);
}
