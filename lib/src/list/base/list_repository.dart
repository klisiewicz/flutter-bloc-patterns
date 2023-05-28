/// [ListRepository] handles all data operations. It knows where to get the data
/// from and what API calls to make when data is updated.
///
/// [T] - the type of returned items.
abstract interface class ListRepository<T> {
  /// Retrieves all items.
  Future<List<T>> getAll();
}
