import 'package:example/src/common/loading_page_indicator.dart';
import 'package:example/src/common/posts_list.dart';
import 'package:example/src/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:infinite_widgets/infinite_widgets.dart';

class PostsListPaged extends StatelessWidget {
  final PagedList<Post> state;
  final VoidCallback onLoadNextPage;

  const PostsListPaged(this.state, {
    Key key,
    @required this.onLoadNextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfiniteListView.separated(
      itemBuilder: (context, index) => PostListItem(state.elements[index]),
      itemCount: state.elements.length,
      hasNext: state.hasMoreElements,
      nextData: onLoadNextPage,
      loadingWidget: LoadingPageIndicator(),
      separatorBuilder: (context, index) => Divider(height: 1),
    );
  }
}
