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
        create: (_) => ListBloc<Post>(PostListRepository()),
        child: PostsPage(),
      ),
    );
  }
}

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostsBloc>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: const PostsViewStateBuilder(),
    );
  }
}

class PostsViewStateBuilder extends StatelessWidget {
  const PostsViewStateBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewStateBuilder<List<Post>, PostsBloc>(
      onLoading: (context) => const LoadingIndicator(),
      onSuccess: (context, posts) =>
          PostsList(posts, onRefresh: () => _refreshPosts(context)),
      onRefreshing: (context, posts) =>
          PostsList(posts, onRefresh: () => _refreshPosts(context)),
      onEmpty: (context) => const PostsListEmpty(),
      onError: (context, error) => ErrorMessage(error: error),
    );
  }

  void _refreshPosts(BuildContext context) {
    context.read<PostsBloc>().refreshItems();
  }
}
