import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_events.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_states.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_repository.dart';

class FilterListBloc<T, F> extends Bloc<ListEvent, ListState> {
  final FilterRepository<T, F> _repository;
  F _filter;

  FilterListBloc(FilterRepository<T, F> repository)
      : assert(repository != null),
        this._repository = repository;

  @override
  ListState get initialState => ListLoading();

  F get filter => _filter;

  void loadItems({F filter}) => dispatch(LoadList(filter));

  void refreshItems({F filter}) => dispatch(RefreshList(filter));

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is LoadList) {
      yield* _mapLoadList(event.filter);
    } else if (event is RefreshList && _isRefreshPossible(event)) {
      yield* _mapRefreshList(event.filter);
    }
  }

  bool _isRefreshPossible(ListEvent event) =>
      currentState is! ListLoading && currentState is! ListRefreshing;

  Stream<ListState> _mapLoadList(F filter) async* {
    yield ListLoading();
    yield* _getItemsFromRepository(filter);
  }

  Stream<ListState> _mapRefreshList(F filter) async* {
    final listItems = _getCurrentStateItems();
    yield ListRefreshing(listItems);
    yield* _getItemsFromRepository(filter);
  }

  List<T> _getCurrentStateItems() =>
      (currentState is ListLoaded) ? (currentState as ListLoaded).items : [];

  Stream<ListState> _getItemsFromRepository(F filter) async* {
    try {
      final List<T> items = await _getDataFromRepository(filter);
      yield items.isNotEmpty
          ? ListLoaded(UnmodifiableListView(items))
          : ListLoadedEmpty();
    } catch (e) {
      yield ListNotLoaded(e);
    } finally {
      _filter = filter;
    }
  }

  Future<List> _getDataFromRepository(F filter) {
    if (filter != null)
      return _repository.getBy(filter);
    else
      return _repository.getAll();
  }
}
