/// [DetailsRepository] allows to retrieve an item based on its id.
///
/// [T] - the type of returned item.
/// [I] - the type of item id.
abstract class DetailsRepository<T, I> {
  /// Retrieves an item with given id.
  Future<T> getById(I id);
}
