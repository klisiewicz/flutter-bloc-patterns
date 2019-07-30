import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_events.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_states.dart';
import 'package:flutter_bloc_patterns/src/list/base/repository.dart';

class ListBloc<T> extends Bloc<ListEvent, ListState> {
  final Repository<T> _repository;

  ListBloc(Repository repository)
      : this._repository = repository,
        assert(repository != null);

  @override
  ListState get initialState => ListLoading();

  void loadItems() => dispatch(LoadList());

  void refreshItems() => dispatch(RefreshList());

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
      final List<T> items = await _repository.getAll();
      yield items.isNotEmpty
          ? ListLoaded(UnmodifiableListView(items))
          : ListLoadedEmpty();
    } catch (e) {
      yield ListNotLoaded(e);
    }
  }
}
