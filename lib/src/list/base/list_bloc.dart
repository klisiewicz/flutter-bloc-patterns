import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_repository.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_list_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_list_repository.dart';
import 'package:flutter_bloc_patterns/src/view/view_state_builder.dart';

/// A basic list BLoC with no filtering or pagination. Thus it should be used
/// with a reasonable small amount of data.
///
/// Designed to collaborate with [ViewStateBuilder] for displaying data.
///
/// Call [loadItems] to perform initial data fetch.
/// Call [refreshItems] to perform a refresh.
///
/// [T] - type of list items.
class ListBloc<T> extends FilterListBloc<T, void> {
  ListBloc(ListRepository<T> repository)
      : super(_FilterRepositoryAdapter(repository));
}

class _FilterRepositoryAdapter<T> implements FilterListRepository<T, void> {
  final ListRepository<T> listRepository;

  _FilterRepositoryAdapter(this.listRepository);

  @override
  Future<List<T>> getAll() => listRepository.getAll();

  @override
  Future<List<T>> getBy(void filter) => listRepository.getAll();
}
