import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

BlocStateAssertion withBloc(Bloc<dynamic, ViewState> bloc) =>
    BlocStateAssertion._internal(bloc);

class BlocStateAssertion {
  final Bloc<dynamic, ViewState> _bloc;

  BlocStateAssertion._internal(this._bloc);

  Future<void> expectStates(Iterable<ViewState> states) {
    return expectLater(
      _bloc.stream,
      emitsInOrder(states),
    );
  }
}
