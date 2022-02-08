import 'package:example/src/common/error_message.dart';
import 'package:example/src/common/loading_indicator.dart';
import 'package:example/src/post/model/post.dart';
import 'package:example/src/post/model/post_repository.dart';
import 'package:example/src/post/ui/posts_list.dart';
import 'package:example/src/post/ui/posts_list_empty.dart';
import 'package:example/src/user/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/filter_list.dart';
import 'package:flutter_bloc_patterns/view.dart';

void main() => runApp(FilterListSampleApp());

const _myUserId = '3';

class FilterListSampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filter List Sample App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BlocProvider(
        create: (_) => FilterListBloc<Post, User>(FilterPostRepository()),
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
  late FilterListBloc<Post, User> listBloc;
  _Posts selectedPosts = _Posts.all;

  @override
  void initState() {
    super.initState();
    listBloc = BlocProvider.of<FilterListBloc<Post, User>>(context)
      ..loadElements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() => AppBar(title: const Text('Posts'));

  Widget _buildBody() {
    return ViewStateBuilder<List<Post>, FilterListBloc<Post, User>>(
      bloc: listBloc,
      onLoading: (context) => const LoadingIndicator(),
      onSuccess: (context, posts) => PostsList(posts, onRefresh: _refreshPosts),
      onRefreshing: (context, posts) =>
          PostsList(posts, onRefresh: _refreshPosts),
      onEmpty: (context) => const PostsListEmpty(),
      onError: (context, error) => ErrorMessage(error: error),
    );
  }

  void _refreshPosts() => listBloc.refreshElements(filter: listBloc.filter);

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: selectedPosts.index,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          label: 'All',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Mine',
        ),
      ],
      onTap: _updateSelectedPosts,
    );
  }

  void _updateSelectedPosts(int index) {
    final user = (index == _Posts.mine.index) ? const User(_myUserId) : null;
    if (user != listBloc.filter) {
      listBloc.loadElements(filter: user);
      setState(() {
        selectedPosts = _Posts.values[index];
      });
    }
  }
}

enum _Posts { all, mine }
