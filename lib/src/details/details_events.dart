import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Base class for details events.
@immutable
sealed class DetailsEvent with EquatableMixin {
  const DetailsEvent();
}

/// Event indicating that details needs to be loaded.
///
/// [I] - the element's [id] type.
final class LoadDetails<I> extends DetailsEvent {
  final I id;

  const LoadDetails(this.id);

  @override
  List<Object?> get props => [id];

  @override
  String toString() => 'LoadDetails: $id';
}
