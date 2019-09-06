import 'package:example/src/common/error_message.dart';
import 'package:example/src/common/loading_indicator.dart';
import 'package:example/src/common/posts_list.dart';
import 'package:example/src/common/posts_list_empty.dart';
import 'package:example/src/model/post.dart';
import 'package:example/src/model/post_repository.dart';
import 'package:example/src/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/filter_list.dart';

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
        builder: (_) => FilterListBloc<Post, User>(FilterPostRepository()),
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
  FilterListBloc<Post, User> listBloc;
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

  AppBar _buildAppBar() => AppBar(title: Text('Posts'));

  Widget _buildBody() {
    return BlocBuilder(
      bloc: listBloc,
      builder: ViewStateBuilder<List<Post>>(
        onLoading: (context) => LoadingIndicator(),
        onSuccess: (context, posts) =>
            PostsList(posts: posts, onRefresh: _refreshPosts),
        onRefreshing: (context, posts) =>
            PostsList(posts: posts, onRefresh: _refreshPosts),
        onEmpty: (context) => PostsListEmpty(),
        onError: (context, error) => ErrorMessage(error: error),
      ).build,
    );
  }

  void _refreshPosts() => listBloc.refreshElements(filter: listBloc.filter);

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: selectedPosts.index,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          title: Text('All'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          title: Text('Mine'),
        ),
      ],
      onTap: _updateSelectedPosts,
    );
  }

  void _updateSelectedPosts(int index) {
    final user = (index == _Posts.mine.index) ? User(_myUserId) : null;
    if (user != listBloc.filter) {
      listBloc.loadElements(filter: user);
      setState(() {
        selectedPosts = _Posts.values[index];
      });
    }
  }
}

enum _Posts { all, mine }
