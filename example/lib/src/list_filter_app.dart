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

enum _Posts { all, mine }

class _PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<_PostsPage> {
  @override
  void initState() {
    super.initState();
    context.read<FilterListBloc<Post, User>>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: const PostsViewStateBuilder(),
      bottomNavigationBar: const PostsBottomNavigationBar(),
    );
  }
}

class PostsViewStateBuilder extends StatelessWidget {
  const PostsViewStateBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewStateBuilder<List<Post>, FilterListBloc<Post, User>>(
      onLoading: (context) => const LoadingIndicator(),
      onSuccess: (context, posts) => PostsList(
        posts,
        onRefresh: () => _refreshPosts(context),
      ),
      onRefreshing: (context, posts) => PostsList(
        posts,
        onRefresh: () => _refreshPosts(context),
      ),
      onEmpty: (context) => const PostsListEmpty(),
      onError: (context, error) => ErrorMessage(error: error),
    );
  }

  void _refreshPosts(BuildContext context) {
    final postsBloc = context.read<FilterListBloc<Post, User>>();
    postsBloc.refreshItems(filter: postsBloc.filter);
  }
}

class PostsBottomNavigationBar extends StatefulWidget {
  const PostsBottomNavigationBar({super.key});

  @override
  State<PostsBottomNavigationBar> createState() =>
      _PostsBottomNavigationBarState();
}

class _PostsBottomNavigationBarState extends State<PostsBottomNavigationBar> {
  _Posts selectedPosts = _Posts.all;

  @override
  Widget build(BuildContext context) {
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
    final user = index == _Posts.mine.index ? const User(_myUserId) : null;
    final postsBloc = context.read<FilterListBloc<Post, User>>();
    if (user != postsBloc.filter) {
      postsBloc.loadItems(filter: user);
      setState(() {
        selectedPosts = _Posts.values[index];
      });
    }
  }
}
