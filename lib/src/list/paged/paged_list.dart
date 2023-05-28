import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// List of items with information whether there could be even more items.
///
/// [T] - type of list items.
@immutable
final class PagedList<T> extends Equatable {
  final List<T> items;
  final bool hasReachedMax;

  /// Creates paged list.
  ///
  /// [items] - list of items, cannot be null or empty,
  /// [hasReachedMax] - flag informing if all items has already been fetched.
  /// True if there are no more pages, false otherwise.
  PagedList(
    List<T> items, {
    this.hasReachedMax = false,
  })  : assert(items.isNotEmpty, 'Items cannot be empty'),
        items = UnmodifiableListView(items);

  bool get hasMoreItems => !hasReachedMax;

  @override
  List<Object> get props => [items, hasReachedMax];

  @override
  String toString() => '$items, hasReachedMax: $hasReachedMax';
}
