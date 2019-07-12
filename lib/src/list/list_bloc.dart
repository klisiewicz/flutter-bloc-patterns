import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/src/list/list_events.dart';
import 'package:flutter_bloc_patterns/src/list/list_states.dart';
import 'package:flutter_bloc_patterns/src/list/repository.dart';

class ListBloc<T> extends Bloc<ListEvent, ListState> {
  final Repository<T> _repository;

  ListBloc(Repository repository)
      : this._repository = repository,
        assert(repository != null);

  @override
  ListState get initialState => ListLoading();

  void loadData() => dispatch(LoadList());

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is LoadList) {
      yield* _mapLoadList();
    }
  }

  Stream<ListState> _mapLoadList() async* {
    try {
      final Iterable<T> items = await _repository.getAll();
      yield items.isNotEmpty
          ? ListLoaded(UnmodifiableListView(items))
          : ListLoadedEmpty();
    } catch (e) {
      yield ListNotLoaded(e);
    }
  }
}
