import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for details events.
@immutable
abstract class DetailsEvent extends Equatable {
  const DetailsEvent();
}

/// Event indicating that details needs to be loaded.
///
/// [I] - the element's [id] type.
class LoadDetails<I> extends DetailsEvent {
  final I id;

  LoadDetails([this.id]);

  @override
  List<Object> get props => [id];

  String toString() => 'LoadDetails: $id';
}
