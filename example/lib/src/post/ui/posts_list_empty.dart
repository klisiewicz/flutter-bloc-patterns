import 'package:flutter/material.dart';

class PostsListEmpty extends StatelessWidget {
  PostsListEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(child: Text('No posts found'));
}
