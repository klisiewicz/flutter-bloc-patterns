import 'package:flutter_bloc_patterns/paged_filter_list.dart';
import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:flutter_bloc_patterns/view.dart';

/// A list BLoC with pagination but without filtering.
///
/// Designed to collaborate with [ViewStateBuilder] for displaying data.
///
/// Call [loadFirstPage] to fetch first page of data.
/// Call [loadNextPage] to fetch next page of data.
///
/// [T] - the type of list items.
class PagedListBloc<T> extends PagedListFilterBloc<T, void> {
  PagedListBloc(PagedListRepository<T> repository)
      : super(_PagedListRepositoryAdapter<T>(repository));
}

class _PagedListRepositoryAdapter<T>
    implements PagedListFilterRepository<T, void> {
  final PagedListRepository<T> pagedListRepository;

  _PagedListRepositoryAdapter(this.pagedListRepository);

  @override
  Future<List<T>> getAll(Page page) => pagedListRepository.getAll(page);

  @override
  Future<List<T>> getBy(Page page, void filter) =>
      pagedListRepository.getAll(page);
}
