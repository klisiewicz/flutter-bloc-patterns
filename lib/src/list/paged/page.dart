import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Pagination information.
@immutable
class Page<T> extends Equatable {
  final int number;
  final int size;
  final int total;
  final List <T>elements;

  /// Creates a [Page] object.
  /// [number] - zero based page index.
  /// [size] - the size of the page to be returned.
  const Page({
    this.number = 0,
    this.size,
    this.elements,
    this.total
  })  : assert(number >= 0, 'Page index must not be less than zero'),
        assert(size >= 1, 'Page size must not be less than one');

  /// Creates first page.
  /// [size] - the size of the page to be returned.
  const Page.first({int size}) : this(number: 0, size: size);

  /// Returns the offset to be taken according to page and page size.
  int get offset => size * number;

  /// Returns true when this is the first page.
  bool get isFirst => number == 0;

  /// Returns next [Page].
  Page<T> next() => Page<T>(number: number + 1, size: size);

  /// Returns the previous [Page] or the first [Page] if the current
  /// one already is the first one.
  Page<T> previous() =>
      (number == 0) ? this : Page<T>(number: number - 1, size: size);

  Page<T> withElements(List<T>elements, {int total}) =>
      Page<T>(number: number, size: size, elements: elements ?? <T>[], total: total);

  @override
  List<Object> get props => [number, size, elements, total];

  @override
  String toString() => '$runtimeType (number: $number, size: $size, total: $total)';
}
