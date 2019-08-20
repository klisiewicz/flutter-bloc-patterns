import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for all list states.
@immutable
abstract class ListState extends Equatable {
  ListState([List props = const []]) : super(props);
}

/// State indicating that the list is loading.
class ListLoading extends ListState {
  @override
  String toString() => 'ListLoading';
}

/// State indicating that the list was loaded successfully, but without any element.
class ListLoadedEmpty extends ListState {
  @override
  String toString() => 'ListLoadedEmpty';
}

/// State indicating that the list is list was loaded successfully with
/// not empty list of elements.
/// [T] - list element type.
class ListLoaded<T> extends ListState {
  final List<T> elements;

  ListLoaded(this.elements)
      : assert(
  elements != null && elements.isNotEmpty,
  'Elements cannot be empty',
  ),
        super([elements]);

  @override
  String toString() => 'ListLoaded: $elements';
}

/// State indicating that the list is refreshing. It can occur only when the
/// initial fetch was successful so it contains the items that has already
/// been loaded.
/// [T] - list element type.
class ListRefreshing<T> extends ListState {
  final List<T> elements;

  ListRefreshing([this.elements = const []])
      : assert(elements != null),
        super([elements]);

  @override
  String toString() => 'ListRefreshing: $elements';
}

/// State indicating that loading or refreshing has failed. It contains an
/// exact [Exception] that has occurred.
class ListNotLoaded extends ListState {
  final Exception exception;

  ListNotLoaded(this.exception)
      : assert(exception != null),
        super([exception]);

  @override
  String toString() => 'ListNotLoaded: $exception';
}
