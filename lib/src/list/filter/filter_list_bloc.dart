import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_events.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_states.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_repository.dart';
import 'package:rxdart/rxdart.dart';

class FilterListBloc<T, F> extends Bloc<ListEvent, ListState> {
  final FilterRepository<T, F> _repository;
  F _filter;

  FilterListBloc(FilterRepository<T, F> repository)
      : assert(repository != null),
        this._repository = repository;

  @override
  ListState get initialState => ListLoading();

  F get filter => _filter;

  void loadData({F filter}) {
    _filter = filter;
    dispatch(LoadList(filter));
  }

  @override
  Stream<ListState> transform(
    Stream<ListEvent> events,
    Stream<ListState> next(ListEvent event),
  ) {
    return super.transform(_distinct(events), next);
  }

  Observable<ListEvent> _distinct(Stream<ListEvent> events) =>
      (events as Observable<ListEvent>).distinct();

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is LoadList) {
      yield* _mapLoadList();
    }
  }

  Stream<ListState> _mapLoadList() async* {
    try {
      yield ListLoading();
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
