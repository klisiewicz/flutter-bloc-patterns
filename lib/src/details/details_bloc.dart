import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/details.dart';
import 'package:flutter_bloc_patterns/src/common/view_state.dart';
import 'package:flutter_bloc_patterns/src/details/details_events.dart';
import 'package:flutter_bloc_patterns/src/details/details_repository.dart';

/// A BLoC that allows to fetch a single element with given identifier.
///
/// Designed to collaborate with [ViewStateBuilder] for displaying data.
///
/// Call [loadElement] to fetch an element with given identifier.
///
/// [T] - the type of the element.
/// [I] - the type of id.
class DetailsBloc<T, I> extends Bloc<DetailsEvent, ViewState> {
  final DetailsRepository<T, I> _detailsRepository;

  DetailsBloc(DetailsRepository<T, I> detailsRepository)
      : assert(detailsRepository != null),
        this._detailsRepository = detailsRepository;

  @override
  ViewState get initialState => Initial();

  /// Loads an element with given [id].
  void loadElement([I id]) => add(LoadDetails(id));

  @override
  Stream<ViewState> mapEventToState(DetailsEvent event) async* {
    if (event is LoadDetails) {
      yield* _mapLoadDetails(event.id);
    }
  }

  Stream<ViewState> _mapLoadDetails(I id) async* {
    try {
      yield Loading();
      final element = await _detailsRepository.getById(id);
      yield element != null ? Success<T>(element) : Empty();
    } on ElementNotFoundException {
      yield Empty();
    } catch (e) {
      yield Failure(e);
    }
  }
}
