import 'package:flutter_bloc_patterns/paged_filter_list.dart';
import 'package:flutter_bloc_patterns/src/list/paged/page.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_filter_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_repository.dart';

/// A list BLoC with pagination but without filtering.
///
/// Designed to collaborate with [ViewStateBuilder] for displaying data.
///
/// Call [loadFirstPage] to fetch first page of data.
/// Call [loadNextPage] to fetch next page of data.
///
/// [T] - the type of list elements.
class PagedListBloc<T> extends PagedListFilterBloc<T, void> {
  PagedListBloc(PagedListRepository<T> pagedListRepository)
      : assert(pagedListRepository != null),
        super(_PagedListRepositoryAdapter<T>(pagedListRepository));
}

class _PagedListRepositoryAdapter<T>
    implements PagedListFilterRepository<T, void> {
  final PagedListRepository<T> pagedListRepository;

  _PagedListRepositoryAdapter(this.pagedListRepository);

  @override
  Future<Page<T>> getAll(Page<T> page) => pagedListRepository.getAll(page);

  @override
  Future<Page<T>> getBy(Page<T> page, void filter) =>
      pagedListRepository.getAll(page);
}
