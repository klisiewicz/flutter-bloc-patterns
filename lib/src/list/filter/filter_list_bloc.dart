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
/// Call [loadItems] to perform initial data fetch.
/// Call [refreshItems] to perform a refresh.
///
/// [T] - the type of list items.
/// [F] - the type of filter.
class FilterListBloc<T, F> extends Bloc<ListEvent<F>, ViewState<List<T>>> {
  final FilterListRepository<T, F> _repository;

  F? _filter;

  F? get filter => _filter;

  bool get _isRefreshPossible => state is Success<List<T>> || state is Empty;

  List<T> get _currentItems =>
      (state is Success<List<T>>) ? (state as Success<List<T>>).data : [];

  FilterListBloc(FilterListRepository<T, F> repository)
      : _repository = repository,
        super(Initial<List<T>>()) {
    on<LoadList<F>>(_loadList);
    on<RefreshList<F>>(_refreshList);
  }

  /// Loads items using the given [filter].
  ///
  /// It's most suitable for initial data fetch or for retry action when
  /// the first fetch fails. It can also be used when [filter] changes when a
  /// full reload is required.
  void loadItems({F? filter}) => add(LoadList(filter));

  /// Refreshes items using the given [filter].
  ///
  /// The refresh is designed for being called after the initial fetch
  /// succeeds. It can be performed when the list has already been loaded.
  ///
  /// It can be used when [filter] changes and there's no need for displaying a
  /// loading indicator.
  void refreshItems({F? filter}) => add(RefreshList(filter));

  Future<void> _loadList(
    LoadList<F> event,
    Emitter<ViewState<List<T>>> emit,
  ) async {
    emit(Loading<List<T>>());
    await _loadItems(event, emit);
  }

  Future<void> _refreshList(
    RefreshList<F> event,
    Emitter<ViewState> emit,
  ) async {
    if (_isRefreshPossible) {
      emit(Refreshing<List<T>>(_currentItems));
      await _loadItems(event, emit);
    }
  }

  Future<void> _loadItems(
    ListEvent<F> event,
    Emitter<ViewState> emit,
  ) async {
    try {
      final items = await _getItems(event.filter);
      if (items.isNotEmpty) {
        emit(Success<List<T>>(UnmodifiableListView(items)));
      } else {
        emit(Empty<List<T>>());
      }
    } catch (e) {
      emit(Failure<List<T>>(e));
    } finally {
      _filter = event.filter;
    }
  }

  Future<List<T>> _getItems(F? filter) {
    if (filter != null) {
      return _repository.getBy(filter);
    } else {
      return _repository.getAll();
    }
  }
}
