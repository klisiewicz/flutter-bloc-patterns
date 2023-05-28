import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_patterns/src/list/paged/page.dart';

/// Base class for paged list events.
@immutable
sealed class PagedListEvent with EquatableMixin {
  const PagedListEvent();
}

/// Event indicating that a page needs to be loaded.
///
/// [F] - the filter type.
final class LoadPage<F> extends PagedListEvent {
  final Page page;
  final F? filter;

  const LoadPage(
    this.page, {
    this.filter,
  });

  @override
  List<Object?> get props => [page, filter];

  @override
  String toString() => 'LoadPage: $page ${filter ?? ''}';
}
