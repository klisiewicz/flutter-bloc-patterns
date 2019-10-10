import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/src/common/view_state.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_events.dart';
import 'package:flutter_bloc_patterns/src/list/filter/filter_list_repository.dart';

/// A list BLoC with allowing filtering capabilities but without pagination.
/// Thus it should be used with a reasonable small amount of data.
///
/// Designed to collaborate with [BlocBuilder] and [ViewStateBuilder] for
/// displaying data.
///
/// Call [loadElements] to perform initial data fetch.
/// Call [refreshElements] to perform a refresh.
///
/// [T] - the type of list elements.
/// [F] - the type of filter.
class FilterListBloc<T, F> extends Bloc<ListEvent, ViewState> {
  final FilterRepository<T, F> _repository;
  F _filter;

  FilterListBloc(FilterRepository<T, F> repository)
      : assert(repository != null),
        this._repository = repository;

  @override
  ViewState get initialState => Loading();

  F get filter => _filter;

  /// Loads elements using the given [filter].
  ///
  /// It's most suitable for initial data fetch or for retry action when
  /// the first fetch fails. It can also be used when [filter] changes when a
  /// full reload is required.
  void loadElements({F filter}) => dispatch(LoadList(filter));

  /// Refreshes elements using the given [filter].
  ///
  /// The refresh is designed for being called after the initial fetch
  /// succeeds. It can be performed when the list has already been loaded.
  ///
  /// It can be used when [filter] changes and there's no need for displaying a
  /// loading indicator.
  void refreshElements({F filter}) => dispatch(RefreshList(filter));

  @override
  Stream<ViewState> mapEventToState(ListEvent event) async* {
    if (event is LoadList) {
      yield* _mapLoadList(event.filter);
    } else if (event is RefreshList && _isRefreshPossible(event)) {
      yield* _mapRefreshList(event.filter);
    }
  }

  bool _isRefreshPossible(ListEvent event) =>
      currentState is Success || currentState is Empty;

  Stream<ViewState> _mapLoadList(F filter) async* {
    yield Loading();
    yield* _getListState(filter);
  }

  Stream<ViewState> _mapRefreshList(F filter) async* {
    final elements = _getCurrentStateElements();
    yield Refreshing(elements);
    yield* _getListState(filter);
  }

  List<T> _getCurrentStateElements() =>
      (currentState is Success) ? (currentState as Success).data : [];

  Stream<ViewState> _getListState(F filter) async* {
    try {
      final List<T> elements = await _getElementsFromRepository(filter);
      yield elements.isNotEmpty
          ? Success<List<T>>(UnmodifiableListView(elements))
          : Empty();
    } catch (e) {
      yield Failure(e);
    } finally {
      _filter = filter;
    }
  }

  Future<List> _getElementsFromRepository(F filter) {
    if (filter != null) {
      return _repository.getBy(filter);
    } else {
      return _repository.getAll();
    }
  }
}
