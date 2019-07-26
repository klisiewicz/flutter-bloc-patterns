import 'package:flutter_bloc_patterns/src/list/base/repository.dart';

abstract class FilterRepository<T, F> extends Repository<T> {
  Future<List<T>> getBy(F filter);
}
