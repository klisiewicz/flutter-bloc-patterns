import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/details.dart';
import 'package:flutter_bloc_patterns/src/details/details_events.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_bloc_patterns/src/view/view_state_builder.dart';

/// A BLoC that allows to fetch a single element with given identifier.
///
/// Designed to collaborate with [ViewStateBuilder] for displaying data.
///
/// Call [loadItem] to fetch an element with given identifier.
///
/// [T] - the type of the element.
/// [I] - the type of id.
class DetailsBloc<T, I> extends Bloc<DetailsEvent, ViewState<T>> {
  final DetailsRepository<T, I> _repository;

  DetailsBloc(DetailsRepository<T, I> repository)
      : _repository = repository,
        super(Initial<T>()) {
    on<LoadDetails<I>>(_loadItemWithId);
  }

  /// Loads an element with given [id].
  void loadItem(I id) => add(LoadDetails(id));

  Future<void> _loadItemWithId(
    LoadDetails<I> event,
    Emitter<ViewState> emit,
  ) async {
    try {
      emit(Loading<T>());
      final item = await _repository.getById(event.id);
      emit(item != null ? Success<T>(item) : Empty<T>());
    } catch (e) {
      emit(Failure<T>(e));
    }
  }
}
