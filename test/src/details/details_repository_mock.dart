import 'package:flutter_bloc_patterns/src/details/details_repository.dart';

const _delay = Duration.zero;

class InMemoryDetailsRepository<T, I> implements DetailsRepository<T, I> {
  final Map<I, T> items;

  InMemoryDetailsRepository([this.items = const {}]);

  @override
  Future<T?> getById(I id) => Future.delayed(_delay, () => items[id]);
}

class FailingDetailsRepository<T, I> implements DetailsRepository<T, I> {
  final Object error;

  FailingDetailsRepository(this.error);

  @override
  Future<T?> getById(I id) async => Future.delayed(_delay, () => throw error);
}
