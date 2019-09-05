import 'package:flutter_bloc_patterns/src/details/details_repository.dart';

class InMemoryDetailsRepository<T, I> extends DetailsRepository<T, I> {
  final Map<I, T> elements;

  InMemoryDetailsRepository([this.elements = const {}]);

  @override
  Future<T> getById(I id) async => elements[id];
}

class FailingDetailsRepository<T, I> extends DetailsRepository<T, I> {
  final dynamic error;

  FailingDetailsRepository(this.error);

  @override
  Future<T> getById(I id) async => throw error;
}
