import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/src/details/details_events.dart';
import 'package:flutter_bloc_patterns/src/details/details_repository.dart';
import 'package:flutter_bloc_patterns/src/details/details_states.dart';
import 'package:flutter_bloc_patterns/src/details/details_view_builder.dart';

/// A BLoC that allows to fetch a single element with given identifier.
///
/// Designed to collaborate with [BlocBuilder] and [DetailsViewBuilder] for
/// displaying data.
///
/// Call [loadElement] to fetch an element with given identifier.
///
/// [T] - the type of the element.
/// [I] - the type of id.
class DetailsBloc<T, I> extends Bloc<DetailsEvent, DetailsState> {
  final DetailsRepository<T, I> _detailsRepository;

  DetailsBloc(DetailsRepository<T, I> detailsRepository)
      : assert(detailsRepository != null),
        this._detailsRepository = detailsRepository;

  @override
  DetailsState get initialState => DetailsLoading();

  /// Loads an element with given [id].
  void loadElement(I id) => dispatch(LoadDetails(id));

  @override
  Stream<DetailsState> mapEventToState(DetailsEvent event) async* {
    if (event is LoadDetails) {
      yield* _mapLoadDetails(event.id);
    }
  }

  Stream<DetailsState> _mapLoadDetails(I id) async* {
    try {
      final element = await _detailsRepository.getById(id);
      yield element != null ? DetailsLoaded(element) : DetailsNotFound();
    } on ElementNotFoundException {
      yield DetailsNotFound();
    } on Exception catch (e) {
      yield DetailsNotLoaded(e);
    } on Error catch (e) {
      yield DetailsError(e);
    }
  }
}
