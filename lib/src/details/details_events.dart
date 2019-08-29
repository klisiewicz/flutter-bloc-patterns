import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for details events.
@immutable
abstract class DetailsEvent extends Equatable {
  DetailsEvent([List props = const []]) : super(props);
}

/// Event indicating that details needs to be loaded.
///
/// [I] - the id type.
class LoadDetails<I> extends DetailsEvent {
  final I id;

  LoadDetails([this.id]) : super([id]);

  String toString() => 'LoadDetails: $id';
}
