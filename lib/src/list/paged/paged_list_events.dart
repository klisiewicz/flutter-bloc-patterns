import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_patterns/src/list/paged/page.dart';
import 'package:meta/meta.dart';

/// Base class for paged list events.
@immutable
abstract class PagedListEvent extends Equatable {
  PagedListEvent([List props = const []]) : super(props);
}

/// Event indicating that a page needs to be loaded.
class LoadPage extends PagedListEvent {
  final Page page;

  LoadPage(this.page)
      : assert(page != null),
        super([page]);

  @override
  String toString() => 'LoadPage: $page';
}
