import 'package:flutter/material.dart';

class PostsListEmpty extends StatelessWidget {
  const PostsListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No posts found'),
    );
  }
}
