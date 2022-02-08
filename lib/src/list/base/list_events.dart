import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Base class for all list events.
@immutable
abstract class ListEvent extends Equatable {
  const ListEvent();
}

/// Event for indicating that initial list load needs to be performed.
///
/// [F] - the filter type.
class LoadList<F> extends ListEvent {
  final F? filter;

  const LoadList([this.filter]);

  @override
  List<Object?> get props => [filter];

  @override
  String toString() => 'LoadList: $filter';
}

/// Event for indicating that list needs to be refreshed.
///
/// [F] - the filter type.
class RefreshList<F> extends ListEvent {
  final F? filter;

  const RefreshList([this.filter]);

  @override
  List<Object?> get props => [filter];

  @override
  String toString() => 'RefreshList: $filter';
}
