import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_events.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_states.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_repository.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_view_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A list BLoC with allowing filtering capabilities but without pagination.
/// Thus it should be used with a reasonable small amount of data.
///
/// Designed to collaborate with [BlocBuilder] and [ListViewBuilder] for
/// displaying data.
///
/// Call [loadItems] to perform initial data fetch.
/// Call [refreshItems] to perform a refresh.
///
/// [T] - the type of list items.
/// [F] - the type of filter.
class FilterListBloc<T, F> extends Bloc<ListEvent, ListState> {
  final FilterRepository<T, F> _repository;
  F _filter;

  FilterListBloc(FilterRepository<T, F> repository)
      : assert(repository != null),
        this._repository = repository;

  @override
  ListState get initialState => ListLoading();

  F get filter => _filter;

  /// Loads items using the given [filter].
  ///
  /// It's most suitable for initial data fetch or for retry action when
  /// the first fetch fails. It can also be used when [filter] changes when a
  /// full reload is required.
  void loadItems({F filter}) => dispatch(LoadList(filter));

  /// Refreshes items using the given [filter].
  ///
  /// The refresh is designed for being called after the initial fetch
  /// succeeds. It can be performed when the list has already been loaded.
  ///
  /// It can be used when [filter] changes when there's no need for displaying a
  /// loading indicator.
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
      currentState is ListLoaded && currentState is ListLoadedEmpty;

  Stream<ListState> _mapLoadList(F filter) async* {
    yield ListLoading();
    yield* _getListState(filter);
  }

  Stream<ListState> _mapRefreshList(F filter) async* {
    final listItems = _getCurrentStateItems();
    yield ListRefreshing(listItems);
    yield* _getListState(filter);
  }

  List<T> _getCurrentStateItems() =>
      (currentState is ListLoaded) ? (currentState as ListLoaded).items : [];

  Stream<ListState> _getListState(F filter) async* {
    try {
      final List<T> items = await _getItemsFromRepository(filter);
      yield items.isNotEmpty
          ? ListLoaded(UnmodifiableListView(items))
          : ListLoadedEmpty();
    } catch (e) {
      yield ListNotLoaded(e);
    } finally {
      _filter = filter;
    }
  }

  Future<List> _getItemsFromRepository(F filter) {
    if (filter != null)
      return _repository.getBy(filter);
    else
      return _repository.getAll();
  }
}
