import 'package:flutter_bloc_patterns/src/details/details_repository.dart';

class InMemoryDetailsRepository<T, I> implements DetailsRepository<T, I> {
  final Map<I, T> items;

  InMemoryDetailsRepository({
    required this.items,
  });

  @override
  Future<T?> getById(I id) {
    return Future.delayed(Duration.zero, () => items[id]);
  }
}

class FailingDetailsRepository<T, I> implements DetailsRepository<T, I> {
  final Object error;

  FailingDetailsRepository(this.error);

  @override
  Future<T?> getById(I id) async {
    return Future.delayed(Duration.zero, () => throw error);
  }
}
