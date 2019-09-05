import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_repository.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_list_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_list_repository.dart';

/// A basic list BLoC with no filtering or pagination. Thus it should be used
/// with a reasonable small amount of data.
///
/// Designed to collaborate with [BlocBuilder] and [ViewStateBuilder] for
/// displaying data.
///
/// Call [loadElements] to perform initial data fetch.
/// Call [refreshElements] to perform a refresh.
///
/// [T] - type of list items.
class ListBloc<T> extends FilterListBloc<T, Null> {
  ListBloc(Repository<T> repository)
      : assert(repository != null),
        super(_FilterRepositoryAdapter(repository));
}

class _FilterRepositoryAdapter<T> extends FilterRepository<T, Null> {
  final Repository<T> repository;

  _FilterRepositoryAdapter(this.repository);

  @override
  Future<List<T>> getAll() => repository.getAll();

  @override
  Future<List<T>> getBy(Null filter) => repository.getAll();
}
