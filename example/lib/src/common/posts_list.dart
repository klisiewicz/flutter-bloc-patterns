import 'package:example/src/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_patterns/base_list.dart';

class PostsList extends StatelessWidget {
  final List<Post> posts;
  final RefreshListCallback onRefresh;

  const PostsList({
    Key key,
    this.posts,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListViewRefresh(
      child: ListView.separated(
        itemCount: posts.length,
        itemBuilder: (context, index) =>
            ListTile(
              title: Text(posts[index].title),
              subtitle: Text(posts[index].body),
            ),
        separatorBuilder: (context, index) => Divider(height: 1),
      ),
      onRefresh: onRefresh,
    );
  }
}
