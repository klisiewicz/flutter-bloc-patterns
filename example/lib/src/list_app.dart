import 'package:example/src/common/error_message.dart';
import 'package:example/src/common/loading_indicator.dart';
import 'package:example/src/common/posts_list.dart';
import 'package:example/src/common/posts_list_empty.dart';
import 'package:example/src/model/post.dart';
import 'package:example/src/model/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/base_list.dart';

class ListSampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Sample App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BlocProvider(
        builder: (BuildContext context) => ListBloc<Post>(PostRepository()),
        child: _PostsPage(),
      ),
    );
  }
}

class _PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<_PostsPage> {
  ListBloc<Post> listBloc;

  @override
  void initState() {
    super.initState();
    listBloc = BlocProvider.of<ListBloc<Post>>(context)..loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: BlocBuilder(
        bloc: listBloc,
        builder: ListViewBuilder<Post>(
          onLoading: (context) => LoadingIndicator(),
          onResult: (context, posts) => PostsList(posts: posts),
          onNoResult: (context) => PostsListEmpty(),
          onError: (context, error) => ErrorMessage(error: error),
        ).build,
      ),
    );
  }
}
