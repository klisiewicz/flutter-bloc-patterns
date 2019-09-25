import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Pagination information.
@immutable
class Page extends Equatable {
  final int number;
  final int size;

  /// Creates a [Page] object.
  /// [number] - zero based page index.
  /// [size] - the size of the page to be returned.
  Page({
    this.number = 0,
    this.size,
  })  : assert(number >= 0, 'Page index must not be less than zero'),
        assert(size >= 1, 'Page size must not be less than one'),
        super([number, size]);

  /// Creates first page.
  /// [size] - the size of the page to be returned.
  Page.first({int size}) : this(number: 0, size: size);

  /// Returns the offset to be taken according to page and page size.
  int get offset => size * number;

  /// Returns next [Page].
  Page next() => Page(number: number + 1, size: size);

  /// Returns the previous [Page] or the first [Page] if the current
  /// one already is the first one.
  Page previous() =>
      (number == 0) ? this : Page(number: number - 1, size: size);

  @override
  String toString() => 'Page (number: $number, size: $size)';
}