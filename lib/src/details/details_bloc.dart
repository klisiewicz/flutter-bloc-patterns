import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/details.dart';
import 'package:flutter_bloc_patterns/src/details/details_events.dart';
import 'package:flutter_bloc_patterns/src/details/details_repository.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_bloc_patterns/src/view/view_state_builder.dart';

/// A BLoC that allows to fetch a single element with given identifier.
///
/// Designed to collaborate with [ViewStateBuilder] for displaying data.
///
/// Call [loadElement] to fetch an element with given identifier.
///
/// [T] - the type of the element.
/// [I] - the type of id.
class DetailsBloc<T, I> extends Bloc<DetailsEvent, ViewState> {
  final DetailsRepository<T, I> _repository;

  DetailsBloc(this._repository)
      : assert(_repository != null),
        super(const Initial());

  /// Loads an element with given [id].
  void loadElement([I id]) => add(LoadDetails(id));

  @override
  Stream<ViewState> mapEventToState(DetailsEvent event) async* {
    if (event is LoadDetails<I>) {
      yield* _mapLoadDetails(event.id);
    }
  }

  Stream<ViewState> _mapLoadDetails(I id) async* {
    try {
      yield const Loading();
      final element = await _repository.getById(id);
      yield element != null ? Success<T>(element) : const Empty();
    } on ElementNotFoundException {
      yield const Empty();
    } catch (e) {
      yield Failure(e);
    }
  }
}
