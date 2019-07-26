import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ListEvent extends Equatable {
  ListEvent([List props = const []]) : super(props);
}

class LoadList<F> extends ListEvent {
  final F filter;

  LoadList([this.filter]) : super([filter]);

  String toString() => 'LoadList: $filter';
}