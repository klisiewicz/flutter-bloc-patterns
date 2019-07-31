import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for all list events.
@immutable
abstract class ListEvent extends Equatable {
  ListEvent([List props = const []]) : super(props);
}

/// Event for indicating that initial list load needs to be performed.
///
/// [F] - the filter type.
class LoadList<F> extends ListEvent {
  final F filter;

  LoadList([this.filter]) : super([filter]);

  String toString() => 'LoadList: $filter';
}

/// Event for indicating that list needs to be refreshed.
///
/// [F] - the filter type.
class RefreshList<F> extends ListEvent {
  final F filter;

  RefreshList([this.filter]) : super([]);

  String toString() => 'RefreshList: $filter';
}
