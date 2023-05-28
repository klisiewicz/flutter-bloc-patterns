import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/paged_filter_list.dart';
import 'package:flutter_bloc_patterns/src/list/paged/page.dart';
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
/// [T] - the type of list items.
/// [F] - the type of filter.
class PagedListFilterBloc<T, F>
    extends Bloc<PagedListEvent, ViewState<PagedList<T>>> {
  static const defaultPageSize = 10;

  final PagedListFilterRepository<T, F> _repository;

  F? _filter;

  F? get filter => _filter;

  Page? _page;

  List<T> get _currentItems => (state is Success<PagedList<T>>)
      ? (state as Success<PagedList<T>>).data.items
      : [];

  PagedListFilterBloc(PagedListFilterRepository<T, F> repository)
      : _repository = repository,
        super(Initial<PagedList<T>>()) {
    on<LoadPage<F>>(_loadPage);
  }

  /// Loads items using the given [filter] and [pageSize]. When no size
  /// is given [_defaultPageSize] is used.
  ///
  /// It's most suitable for initial data fetch or for retry action when
  /// the first fetch fails.
  void loadFirstPage({
    int pageSize = defaultPageSize,
    F? filter,
  }) {
    _page = Page.first(size: pageSize);
    _filter = filter;
    add(LoadPage(_page!, filter: _filter));
  }

  /// Loads next page. When no page has been loaded before the first one is
  /// loaded with the default page size [_defaultPageSize].
  void loadNextPage() {
    _page = _page?.next() ?? const Page.first(size: defaultPageSize);
    add(LoadPage(_page!, filter: _filter));
  }

  Future<void> _loadPage(
    LoadPage<F> event,
    Emitter<ViewState<PagedList<T>>> emit,
  ) async {
    final page = event.page;
    try {
      _emitLoadingWhenFirstPage(page, emit);
      final pageItems = await _getItems(page, filter);
      pageItems.isEmpty
          ? _emitEmptyPageLoaded(page, emit)
          : _emitNextPageLoaded(page, pageItems, emit);
    } on PageNotFoundException catch (_) {
      _emitEmptyPageLoaded(page, emit);
    } catch (e) {
      emit(Failure<PagedList<T>>(e));
    }
  }

  void _emitLoadingWhenFirstPage(
    Page page,
    Emitter<ViewState<PagedList<T>>> emit,
  ) {
    if (page.isFirst) {
      emit(Loading<PagedList<T>>());
    }
  }

  void _emitEmptyPageLoaded(
    Page page,
    Emitter<ViewState<PagedList<T>>> emit,
  ) {
    emit(
      page.isFirst
          ? Empty<PagedList<T>>()
          : Success<PagedList<T>>(
              PagedList(_currentItems, hasReachedMax: true),
            ),
    );
  }

  void _emitNextPageLoaded(
    Page page,
    List<T> pageItems,
    Emitter<ViewState<PagedList<T>>> emit,
  ) {
    final allItems = _currentItems + pageItems;
    emit(
      Success<PagedList<T>>(
        PagedList(allItems, hasReachedMax: page.size > pageItems.length),
      ),
    );
  }

  Future<List<T>> _getItems(Page page, F? filter) async {
    return filter != null
        ? _repository.getBy(page, filter)
        : _repository.getAll(page);
  }
}
