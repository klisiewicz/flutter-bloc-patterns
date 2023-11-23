import 'package:example/src/common/error_message.dart';
import 'package:example/src/common/loading_indicator.dart';
import 'package:example/src/post/model/post.dart';
import 'package:example/src/post/model/post_repository.dart';
import 'package:example/src/post/ui/posts_list.dart';
import 'package:example/src/post/ui/posts_list_empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/view.dart';

void main() => runApp(ListSampleApp());

typedef PostsBloc = ListBloc<Post>;

class ListSampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Sample App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: BlocProvider(
        create: (_) => ListBloc<Post>(
          PostListRepository(),
        )..loadItems(),
        child: PostsPage(),
      ),
    );
  }
}

class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: ViewStateBuilder<List<Post>, PostsBloc>(
        loading: (context) => const LoadingIndicator(),
        data: (context, posts) => PostsList(
          posts,
          onRefresh: context.read<PostsBloc>().refreshItems,
        ),
        refreshing: (context, posts) => PostsList(
          posts,
          onRefresh: context.read<PostsBloc>().refreshItems,
        ),
        empty: (context) => const PostsListEmpty(),
        error: (context, error) => ErrorMessage(error: error),
      ),
    );
  }
}
