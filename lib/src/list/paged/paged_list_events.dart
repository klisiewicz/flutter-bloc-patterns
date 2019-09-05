import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_patterns/src/list/paged/page.dart';
import 'package:meta/meta.dart';

/// Base class for all paged list events.
@immutable
abstract class PagedListEvent extends Equatable {
  PagedListEvent([List props = const []]) : super(props);
}

class LoadPage extends PagedListEvent {
  final Page page;

  LoadPage(this.page)
      : assert(page != null),
        super([page]);

  @override
  String toString() => 'LoadPage: $page';
}
