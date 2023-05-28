import 'package:example/src/common/error_message.dart';
import 'package:example/src/common/loading_indicator.dart';
import 'package:example/src/post/model/post.dart';
import 'package:example/src/post/model/post_repository.dart';
import 'package:example/src/post/ui/posts_list_empty.dart';
import 'package:example/src/post/ui/posts_list_paged.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:flutter_bloc_patterns/view.dart';

void main() => runApp(PagedListSampleApp());

class PagedListSampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paged List Sample App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: BlocProvider(
        create: (_) => PagedListBloc<Post>(PagedPostRepository()),
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
  @override
  void initState() {
    super.initState();
    context.read<PagedListBloc<Post>>().loadFirstPage(pageSize: 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: ViewStateBuilder<PagedList<Post>, PagedListBloc<Post>>(
        onLoading: (context) => const LoadingIndicator(),
        onSuccess: (context, page) => PostsListPaged(
          page,
          onLoadNextPage: context.read<PagedListBloc<Post>>().loadNextPage,
        ),
        onEmpty: (context) => const PostsListEmpty(),
        onError: (context, error) => ErrorMessage(error: error),
      ),
    );
  }
}
