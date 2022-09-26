import 'package:bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';

BlocStateAssertion<S> withBloc<S>(BlocBase<S> bloc) =>
    BlocStateAssertion._internal(bloc);

class BlocStateAssertion<S> {
  final BlocBase<S> _bloc;

  BlocStateAssertion._internal(this._bloc);

  Future<void> expectStates(Iterable<S> states) {
    return expectLater(
      _bloc.stream,
      emitsInOrder(states),
    );
  }
}
