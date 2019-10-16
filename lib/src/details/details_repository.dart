/// [DetailsRepository] allows to retrieve an item based on its id.
///
/// [T] - the element type.
/// [I] - the element's id type.
abstract class DetailsRepository<T, I> {
  /// Retrieves an element with given id. When there's no element matching the
  /// given [id] null should be returned or [ElementNotFoundException] should
  /// be thrown.
  Future<T> getById(I id);
}

/// Exception indicating that element with [id] was not found in the
/// repository.
class ElementNotFoundException<I> implements Exception {
  final I id;

  ElementNotFoundException(this.id);

  @override
  String toString() => '$runtimeType: Unable to find element with id $id.';
}
