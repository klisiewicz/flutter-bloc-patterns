import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_events.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_list_repository.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_bloc_patterns/src/view/view_state_builder.dart';

/// A list BLoC with allowing filtering capabilities but without pagination.
/// Thus it should be used with a reasonable small amount of data.
///
/// Designed to collaborate with [ViewStateBuilder] for displaying data.
///
/// Call [loadElements] to perform initial data fetch.
/// Call [refreshElements] to perform a refresh.
///
/// [T] - the type of list elements.
/// [F] - the type of filter.
class FilterListBloc<T, F> extends Bloc<ListEvent, ViewState> {
  final FilterListRepository<T, F> _repository;
  F? _filter;

  FilterListBloc(FilterListRepository<T, F> repository)
      : _repository = repository,
        super(const Initial());

  F? get filter => _filter;

  /// Loads elements using the given [filter].
  ///
  /// It's most suitable for initial data fetch or for retry action when
  /// the first fetch fails. It can also be used when [filter] changes when a
  /// full reload is required.
  void loadElements({F? filter}) => add(LoadList(filter));

  /// Refreshes elements using the given [filter].
  ///
  /// The refresh is designed for being called after the initial fetch
  /// succeeds. It can be performed when the list has already been loaded.
  ///
  /// It can be used when [filter] changes and there's no need for displaying a
  /// loading indicator.
  void refreshElements({F? filter}) => add(RefreshList(filter));

  @override
  Stream<ViewState> mapEventToState(ListEvent event) async* {
    if (event is LoadList<F>) {
      yield* _mapLoadList(event.filter);
    } else if (event is RefreshList<F> && _isRefreshPossible(event)) {
      yield* _mapRefreshList(event.filter);
    }
  }

  bool _isRefreshPossible(ListEvent event) =>
      state is Success || state is Empty;

  Stream<ViewState> _mapLoadList(F? filter) async* {
    yield const Loading();
    yield* _getListState(filter);
  }

  Stream<ViewState> _mapRefreshList(F? filter) async* {
    final elements = _getCurrentStateElements();
    yield Refreshing(elements);
    yield* _getListState(filter);
  }

  List<T> _getCurrentStateElements() =>
      (state is Success<List<T>>) ? (state as Success<List<T>>).data : [];

  Stream<ViewState> _getListState(F? filter) async* {
    try {
      final List<T> elements = await _getElementsFromRepository(filter);
      yield elements.isNotEmpty
          ? Success<List<T>>(UnmodifiableListView(elements))
          : const Empty();
    } catch (e) {
      yield Failure(e);
    } finally {
      _filter = filter;
    }
  }

  Future<List<T>> _getElementsFromRepository(F? filter) {
    if (filter != null) {
      return _repository.getBy(filter);
    } else {
      return _repository.getAll();
    }
  }
}
