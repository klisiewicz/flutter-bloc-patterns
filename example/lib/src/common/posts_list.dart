import 'package:example/src/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_patterns/base_list.dart';

class PostsList extends StatelessWidget {
  final List<Post> posts;
  final ListRefreshCallback onRefresh;
  final ValueSetter<Post> onPostSelected;

  const PostsList({
    Key key,
    this.posts,
    this.onRefresh,
    this.onPostSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListViewRefresh(
      child: ListView.separated(
        itemCount: posts.length,
        itemBuilder: (context, index) =>
            PostListItem(
              posts[index],
              onPostSelected: onPostSelected,
            ),
        separatorBuilder: (context, index) => Divider(height: 1),
      ),
      onRefresh: onRefresh,
    );
  }
}

class PostListItem extends StatelessWidget {
  final Post post;
  final ValueSetter<Post> onPostSelected;

  const PostListItem(this.post, {
    this.onPostSelected,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ListTile(
        title: Text(post.title),
        onTap: () {
          onPostSelected?.call(post);
        },
      );
}
