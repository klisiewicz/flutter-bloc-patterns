import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/src/common/state.dart';
import 'package:flutter_bloc_patterns/src/list/paged/page.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_events.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_list_state.dart';
import 'package:flutter_bloc_patterns/src/list/paged/paged_repository.dart';

class PagedListBloc<T> extends Bloc<PagedListEvent, State> {
  static const _defaultPageSize = 10;
  final PagedRepository<T> _pagedRepository;

  PagedListBloc(PagedRepository<T> pagedRepository)
      : assert(pagedRepository != null),
        this._pagedRepository = pagedRepository;

  @override
  State get initialState => Loading();

  List<T> get _currentElements =>
      (currentState is Success) ? (currentState as Success).data.elements : [];

  Page _page;

  void loadFirstPage({int pageSize = _defaultPageSize}) {
    _page = Page.first(size: pageSize);
    dispatch(LoadPage(_page));
  }

  void loadNextPage() {
    _page = _page?.next() ?? Page.first(size: _defaultPageSize);
    dispatch(LoadPage(_page));
  }

  @override
  Stream<State> mapEventToState(PagedListEvent event) async* {
    if (event is LoadPage) {
      yield* _mapLoadPage(event.page);
    }
  }

  Stream<State> _mapLoadPage(Page page) async* {
    try {
      final List<T> pageElements = await _pagedRepository.getAll(page);
      if (pageElements.isEmpty) {
        yield* _emitEmptyPageLoaded();
      } else {
        yield* _emitNextPageLoaded(pageElements);
      }
    } on PageNotFoundException catch (_) {
      yield* _emitEmptyPageLoaded();
    } catch (e) {
      yield Failure(e);
    }
  }

  Stream<State> _emitEmptyPageLoaded() async* {
    yield (_currentElements.isEmpty)
        ? Empty()
        : Success(PagedListState<T>(_currentElements, hasReachedMax: true));
  }

  Stream<State> _emitNextPageLoaded(List<T> pageElements) async* {
    final List<T> allElements = _currentElements + pageElements;
    yield Success(PagedListState<T>(allElements));
  }
}
