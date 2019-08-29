import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/src/details/details_events.dart';
import 'package:flutter_bloc_patterns/src/details/details_repository.dart';
import 'package:flutter_bloc_patterns/src/details/details_states.dart';

class DetailsBloc<T, I> extends Bloc<DetailsEvent, DetailsState> {
  final DetailsRepository<T, I> _detailsRepository;

  DetailsBloc(DetailsRepository<T, I> detailsRepository)
      : assert(detailsRepository != null),
        this._detailsRepository = detailsRepository;

  @override
  DetailsState get initialState => DetailsLoading();

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
    } catch (e) {
      yield DetailsNotLoaded(e);
    }
  }
}
