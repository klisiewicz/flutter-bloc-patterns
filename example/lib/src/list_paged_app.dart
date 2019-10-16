import 'package:example/src/common/error_message.dart';
import 'package:example/src/common/loading_indicator.dart';
import 'package:example/src/common/posts_list_empty.dart';
import 'package:example/src/common/posts_list_paged.dart';
import 'package:example/src/model/post.dart';
import 'package:example/src/model/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/paged_list.dart';

void main() => runApp(PagedListSampleApp());

class PagedListSampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paged List Sample App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: BlocProvider(
        builder: (_) => PagedListBloc<Post>(PagedPostRepository()),
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
  PagedListBloc _listBloc;

  @override
  void initState() {
    super.initState();
    _listBloc = BlocProvider.of<PagedListBloc<Post>>(context)
      ..loadFirstPage(pageSize: 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: BlocBuilder(
        bloc: _listBloc,
        builder: ViewStateBuilder(
          onLoading: (context) => LoadingIndicator(),
          onSuccess: (context, page) =>
              PostsListPaged(
                page,
                onLoadNextPage: _listBloc.loadNextPage,
              ),
          onEmpty: (context) => PostsListEmpty(),
          onError: (context, error) => ErrorMessage(error: error),
        ).build,
      ),
    );
  }

  @override
  void dispose() {
    _listBloc.close();
    super.dispose();
  }
}
