import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class PagedListState<T> extends Equatable {
  final List<T> elements;
  final bool hasReachedMax;

  PagedListState(this.elements, {this.hasReachedMax = false})
      : assert(
          elements != null && elements.isNotEmpty,
          'Elements cannot be empty',
        ),
        super([elements, hasReachedMax]);

  PagedListState<T> copyWith({List<T> elements, bool hasReachedMax}) =>
      PagedListState(
        elements ?? this.elements,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );

  @override
  String toString() => '$elements, hasReachedMax: $hasReachedMax';
}
