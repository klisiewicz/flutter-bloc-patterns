import 'package:example/src/common/error_message.dart';
import 'package:example/src/common/loading_indicator.dart';
import 'package:example/src/post/model/post.dart';
import 'package:example/src/post/model/post_repository.dart';
import 'package:example/src/post/ui/posts_list.dart';
import 'package:example/src/post/ui/posts_list_empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/view.dart';

void main() => runApp(ListSampleApp());

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
  ListBloc<Post> listBloc;

  @override
  void initState() {
    super.initState();
    listBloc = BlocProvider.of<ListBloc<Post>>(context)..loadElements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: ViewStateBuilder<List<Post>, ListBloc<Post>>(
        bloc: listBloc,
        onLoading: (context) => const LoadingIndicator(),
        onSuccess: (context, List<Post> posts) =>
            PostsList(posts, onRefresh: _refreshPosts),
        onRefreshing: (context, List<Post> posts) =>
            PostsList(posts, onRefresh: _refreshPosts),
        onEmpty: (context) => const PostsListEmpty(),
        onError: (context, error) => ErrorMessage(error: error),
      ),
    );
  }

  void _refreshPosts() => listBloc.refreshElements();
}
