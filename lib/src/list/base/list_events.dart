import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Base class for all list events.
///
/// [F] - the filter type.
@immutable
sealed class ListEvent<F> with EquatableMixin {
  final F? filter;

  const ListEvent([this.filter]);

  @override
  List<Object?> get props => [filter];
}

/// Event for indicating that initial list load needs to be performed.
///
/// [F] - the filter type.
final class LoadList<F> extends ListEvent<F> {
  const LoadList([super.filter]);

  @override
  String toString() => 'LoadList: $filter';
}

/// Event for indicating that list needs to be refreshed.
///
/// [F] - the filter type.
final class RefreshList<F> extends ListEvent<F> {
  const RefreshList([super.filter]);

  @override
  String toString() => 'RefreshList: $filter';
}
