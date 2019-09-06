import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// List of elements with information whether there could be even more elements.
///
/// [T] - type of list elements.
@immutable
class PagedList<T> extends Equatable {
  final List<T> elements;
  final bool hasReachedMax;

  /// Creates paged list.
  ///
  /// [elements] - list of elements, cannot be null or empty,
  /// [hasReachedMax] - flag informing if all elements has already been fetched.
  /// True if there are more pages, false otherwise.
  PagedList(this.elements, {this.hasReachedMax = false})
      : assert(
          elements != null && elements.isNotEmpty,
          'Elements cannot be empty',
        ),
        super([elements, hasReachedMax]);

  @override
  String toString() => '$elements, hasReachedMax: $hasReachedMax';
}
