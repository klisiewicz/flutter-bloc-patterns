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

  void loadItems({F filter}) {
    _filter = filter;
    dispatch(LoadList(filter));
  }

  void refreshItems({F filter}) {
    _filter = filter;
    dispatch(RefreshList(filter));
  }

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is LoadList) {
      yield* _mapLoadList();
    } else if (_isRefreshPossible(event)) {
      yield* _mapRefreshList();
    }
  }

  bool _isRefreshPossible(ListEvent event) =>
      event is RefreshList &&
          currentState is! ListLoading &&
          currentState is! ListRefreshing;

  Stream<ListState> _mapLoadList() async* {
    yield ListLoading();
    yield* _getItemsFromRepository();
  }

  Stream<ListState> _mapRefreshList() async* {
    final listItems = _getCurrentStateItems();
    yield ListRefreshing(listItems);
    yield* _getItemsFromRepository();
  }

  List<T> _getCurrentStateItems() =>
      (currentState is ListLoaded) ? (currentState as ListLoaded).items : [];

  Stream<ListState> _getItemsFromRepository() async* {
    try {
      final List<T> items = await _getDataFromRepository();
      yield items.isNotEmpty
          ? ListLoaded(UnmodifiableListView(items))
          : ListLoadedEmpty();
    } catch (e) {
      yield ListNotLoaded(e);
    }
  }

  Future<List> _getDataFromRepository() {
    if (_filter != null)
      return _repository.getBy(_filter);
    else
      return _repository.getAll();
  }
}
