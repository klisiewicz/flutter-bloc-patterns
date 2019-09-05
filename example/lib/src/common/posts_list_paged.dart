import 'package:example/src/common/loading_page_indicator.dart';
import 'package:example/src/common/posts_list.dart';
import 'package:example/src/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/paged_list.dart';

class PostsListPaged extends StatefulWidget {
  final PagedListState state;

  const PostsListPaged(this.state, {Key key}) : super(key: key);

  @override
  _PostsListPagedState createState() => _PostsListPagedState();
}

class _PostsListPagedState extends State<PostsListPaged> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _loadNextPageWhenScrolled,
      child: ListView.separated(
        itemCount: getElementsCount(widget.state),
        itemBuilder: (context, index) => index >= widget.state.elements.length
            ? LoadingPageIndicator()
            : PostListItem(widget.state.elements[index]),
        separatorBuilder: (context, index) => Divider(height: 1),
        controller: _scrollController,
      ),
    );
  }

  bool _loadNextPageWhenScrolled(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      BlocProvider.of<PagedListBloc<Post>>(context).loadNextPage();
    }
    return false;
  }

  int getElementsCount(PagedListState<Post> state) =>
      state.hasReachedMax ? state.elements.length : state.elements.length + 1;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
