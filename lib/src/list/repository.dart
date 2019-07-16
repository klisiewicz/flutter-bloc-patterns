abstract class Repository<T> {
  Future<List<T>> getAll();
}
