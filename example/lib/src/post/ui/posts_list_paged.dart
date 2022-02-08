import 'package:example/src/common/loading_page_indicator.dart';
import 'package:example/src/post/model/post.dart';
import 'package:example/src/post/ui/posts_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:infinite_widgets/infinite_widgets.dart';

class PostsListPaged extends StatelessWidget {
  final PagedList<Post> page;
  final VoidCallback onLoadNextPage;

  const PostsListPaged(
    this.page, {
    Key? key,
    required this.onLoadNextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfiniteListView(
      itemBuilder: (context, index) => PostListItem(page.elements[index]),
      itemCount: page.elements.length,
      hasNext: page.hasMoreElements,
      nextData: onLoadNextPage,
      loadingWidget: const LoadingPageIndicator(),
    );
  }
}
