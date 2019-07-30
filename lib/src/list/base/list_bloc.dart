import 'package:flutter_bloc_patterns/src/list/base/repository.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_list_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_repository.dart';

class ListBloc<T> extends FilterListBloc<T, void> {
  ListBloc(Repository<T> repository)
      : assert(repository != null),
        super(_FilterRepositoryAdapter(repository));
}

class _FilterRepositoryAdapter<T> extends FilterRepository<T, void> {
  final Repository<T> repository;

  _FilterRepositoryAdapter(this.repository);

  @override
  Future<List<T>> getAll() => repository.getAll();

  @override
  Future<List<T>> getBy(void filter) => repository.getAll();
}
