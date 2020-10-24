import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/paged_filter_list.dart';
import 'package:flutter_bloc_patterns/src/list/paged/page.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_events.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_repository.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_bloc_patterns/src/view/view_state_builder.dart';

/// A list BLoC with pagination and filtering.
///
/// Designed to collaborate with [ViewStateBuilder] for displaying data.
///
/// Call [loadFirstPage] to fetch first page of data. This is where filter
/// value can be set as well as the page size and these values cannot be changed
/// when loading the next page.
/// Call [loadNextPage] to fetch next page of data.
///
/// [T] - the type of list elements.
/// [F] - the type of filter.
class PagedListFilterBloc<T, F> extends Bloc<PagedListEvent, ViewState> {
  static const defaultPageSize = 10;

  final PagedListFilterRepository<T, F> _repository;
  F _filter;

  PagedListFilterBloc(PagedListFilterRepository<T, F> repository)
      : assert(repository != null),
        _repository = repository,
        super(const Initial());

  List<T> get _currentElements => (state is Success<PagedList<T>>)
      ? (state as Success<PagedList<T>>).data.elements
      : [];

  Page _page;

  F get filter => _filter;

  /// Loads elements using the given [filter] and [pageSize]. When no size
  /// is given [_defaultPageSize] is used.
  ///
  /// It's most suitable for initial data fetch or for retry action when
  /// the first fetch fails.
  void loadFirstPage({int pageSize = defaultPageSize, F filter}) {
    _page = Page.first(size: pageSize);
    _filter = filter;
    add(LoadPage(_page, filter: _filter));
  }

  /// Loads next page. When no page has been loaded before the first one is
  /// loaded with the default page size [_defaultPageSize].
  void loadNextPage() {
    _page = _page?.next() ?? const Page.first(size: defaultPageSize);
    add(LoadPage(_page, filter: _filter));
  }

  @override
  Stream<ViewState> mapEventToState(PagedListEvent event) async* {
    if (event is LoadPage<F>) {
      yield* _mapLoadPage(event.page, event.filter);
    }
  }

  Stream<ViewState> _mapLoadPage(Page page, F filter) async* {
    try {
      yield* _emitLoadingWhenFirstPage(page);
      final List<T> pageElements = await _repository.getBy(page, filter);
      yield* (pageElements.isEmpty)
          ? _emitEmptyPageLoaded(page)
          : _emitNextPageLoaded(page, pageElements);
    } on PageNotFoundException catch (_) {
      yield* _emitEmptyPageLoaded(page);
    } catch (e) {
      yield Failure(e);
    }
  }

  Stream<ViewState> _emitLoadingWhenFirstPage(Page page) async* {
    if (page.isFirst) {
      yield const Loading();
    }
  }

  Stream<ViewState> _emitEmptyPageLoaded(Page page) async* {
    yield (page.isFirst)
        ? const Empty()
        : Success(PagedList<T>(_currentElements, hasReachedMax: true));
  }

  Stream<ViewState> _emitNextPageLoaded(
    Page page,
    List<T> pageElements,
  ) async* {
    final List<T> allElements = _currentElements + pageElements;
    yield Success(
      PagedList<T>(allElements, hasReachedMax: page.size > pageElements.length),
    );
  }
}
