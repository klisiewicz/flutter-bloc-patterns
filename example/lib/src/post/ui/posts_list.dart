import 'package:example/src/post/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_patterns/view.dart';

class PostsList extends StatelessWidget {
  final List<Post> posts;
  final VoidCallback? onRefresh;
  final ValueSetter<Post>? onPostSelected;

  const PostsList(
    this.posts, {
    Key? key,
    this.onRefresh,
    this.onPostSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshView(
      onRefresh: onRefresh,
      child: ListView.separated(
        itemCount: posts.length,
        itemBuilder: (context, index) => PostListItem(
          posts[index],
          onPostSelected: onPostSelected,
        ),
        separatorBuilder: (context, index) => const Divider(height: 1),
      ),
    );
  }
}

class PostListItem extends StatelessWidget {
  final Post post;
  final ValueSetter<Post>? onPostSelected;

  const PostListItem(
    this.post, {
    this.onPostSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(post.title),
        onTap: () {
          onPostSelected?.call(post);
        },
      );
}
