import 'package:example/src/model/post.dart';
import 'package:flutter/material.dart';

class PostsList extends StatelessWidget {
  final List<Post> posts;

  const PostsList({
    Key key,
    this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: posts.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(posts[index].title),
        subtitle: Text(posts[index].body),
      ),
      separatorBuilder: (context, index) => Divider(height: 1),
    );
  }
}
