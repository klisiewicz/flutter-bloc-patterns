import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/src/common/view_state.dart';
import 'package:flutter_bloc_patterns/src/list/paged/page.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_events.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_repository.dart';

/// A list BLoC with pagination but without filtering.
///
/// Designed to collaborate with [BlocBuilder] and [ViewStateBuilder] for
/// displaying data.
///
/// Call [loadFirstPage] to fetch first page of data
/// Call [loadNextPage] to fetch next page of data.
///
/// [T] - the type of list elements.
class PagedListBloc<T> extends Bloc<PagedListEvent, ViewState> {
  static const _defaultPageSize = 10;
  final PagedRepository<T> _pagedRepository;

  PagedListBloc(PagedRepository<T> pagedRepository)
      : assert(pagedRepository != null),
        this._pagedRepository = pagedRepository;

  @override
  ViewState get initialState => Loading();

  List<T> get _currentElements =>
      (currentState is Success) ? (currentState as Success).data.elements : [];

  Page _page;

  /// Loads first page with given size. When no size is given [_defaultPageSize]
  /// is used.
  void loadFirstPage({int pageSize = _defaultPageSize}) {
    _page = Page.first(size: pageSize);
    dispatch(LoadPage(_page));
  }

  /// Loads next page. When no page has been loaded before the first one is
  /// loaded with the default page size [_defaultPageSize].
  void loadNextPage() {
    _page = _page?.next() ?? Page.first(size: _defaultPageSize);
    dispatch(LoadPage(_page));
  }

  @override
  Stream<ViewState> mapEventToState(PagedListEvent event) async* {
    if (event is LoadPage) {
      yield* _mapLoadPage(event.page);
    }
  }

  Stream<ViewState> _mapLoadPage(Page page) async* {
    try {
      final List<T> pageElements = await _pagedRepository.getAll(page);
      if (pageElements.isEmpty) {
        yield* _emitEmptyPageLoaded(page);
      } else {
        yield* _emitNextPageLoaded(pageElements);
      }
    } on PageNotFoundException catch (_) {
      yield* _emitEmptyPageLoaded(page);
    } catch (e) {
      yield Failure(e);
    }
  }

  Stream<ViewState> _emitEmptyPageLoaded(Page page) async* {
    yield (_isFirst(page))
        ? Empty()
        : Success(PagedList<T>(
      UnmodifiableListView(_currentElements),
      hasReachedMax: true,
    ));
  }

  bool _isFirst(Page page) => page.number == 0;

  Stream<ViewState> _emitNextPageLoaded(List<T> pageElements) async* {
    final List<T> allElements = _currentElements + pageElements;
    yield Success(PagedList<T>(UnmodifiableListView(allElements)));
  }
}
