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

/// State indicating that the list was loaded successfully, but without any item.
class ListLoadedEmpty extends ListState {
  @override
  String toString() => 'ListLoadedEmpty';
}

/// State indicating that the list is list was loaded successfully with
/// not empty list of items.
class ListLoaded<T> extends ListState {
  final List<T> items;

  ListLoaded(this.items)
      : assert(items != null && items.isNotEmpty, 'List items cannot be empty'),
        super([items]);

  @override
  String toString() => 'ListLoaded: $items';
}

/// State indicating that the list is refreshing. It can occur only when the
/// initial fetch was successful so it contains the items that has already
/// been loaded.
class ListRefreshing<T> extends ListState {
  final List<T> items;

  ListRefreshing([this.items = const []])
      : assert(items != null),
        super([items]);

  @override
  String toString() => 'ListRefreshing: $items';
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
