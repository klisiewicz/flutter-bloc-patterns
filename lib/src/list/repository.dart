abstract class Repository<T> {
  Future<Iterable<T>> getAll();
}
