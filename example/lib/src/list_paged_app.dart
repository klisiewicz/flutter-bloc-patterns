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
        create: (_) {
          return PagedListBloc<Post>(PagedPostRepository())
            ..loadFirstPage(pageSize: 20);
        },
        child: _PostsPage(),
      ),
    );
  }
}

class _PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: ViewStateBuilder<PagedList<Post>, PagedListBloc<Post>>(
        loading: (context) => const LoadingIndicator(),
        data: (context, page) => PostsListPaged(
          page,
          onLoadNextPage: context.read<PagedListBloc<Post>>().loadNextPage,
        ),
        empty: (context) => const PostsListEmpty(),
        error: (context, error) => ErrorMessage(error: error),
      ),
    );
  }
}
