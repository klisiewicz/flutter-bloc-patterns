import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for details states.
@immutable
abstract class DetailsState extends Equatable {
  DetailsState([List props = const []]) : super(props);
}

/// State indicating that details are being loaded.
class DetailsLoading<I> extends DetailsState {
  @override
  String toString() => 'DetailsLoading';
}

/// State indicating that there's no item with given id.
class DetailsNotFound extends DetailsState {
  @override
  String toString() => 'DetailsNotFound';
}

/// State indicating that loading details was successful.
/// [T] - item type.
class DetailsLoaded<T> extends DetailsState {
  final T element;

  DetailsLoaded(this.element)
      : assert(element != null, 'Element cannot be null'),
        super([element]);

  @override
  String toString() => 'DetailsLoaded: $element';
}

/// State indicating that loading details has failed. It contains an
/// exact [Exception] that has occurred.
class DetailsNotLoaded extends DetailsState {
  final Exception exception;

  DetailsNotLoaded(this.exception)
      : assert(exception != null),
        super([exception]);

  @override
  String toString() => 'DetailsNotLoaded: $exception';
}
