import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_patterns/src/list/paged/page.dart';
import 'package:meta/meta.dart';

/// Base class for paged list events.
@immutable
abstract class PagedListEvent extends Equatable {
  const PagedListEvent();
}

/// Event indicating that a page needs to be loaded.
class LoadPage extends PagedListEvent {
  final Page page;

  const LoadPage(this.page) : assert(page != null);

  @override
  List<Object> get props => [page];

  @override
  String toString() => 'LoadPage: $page';
}
