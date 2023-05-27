import 'package:example/src/common/error_message.dart';
import 'package:example/src/common/loading_indicator.dart';
import 'package:example/src/post/model/post.dart';
import 'package:example/src/post/model/post_details.dart';
import 'package:example/src/post/model/post_repository.dart';
import 'package:example/src/post/ui/posts_list.dart';
import 'package:example/src/post/ui/posts_list_empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/details.dart';
import 'package:flutter_bloc_patterns/view.dart';

void main() => runApp(ListDetailsSampleApp());

typedef PostsBloc = ListBloc<Post>;
typedef PostDetailsBloc = DetailsBloc<PostDetails, int>;

class ListDetailsSampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Details Sample App',
      initialRoute: _Route.home,
      onGenerateRoute: _Router.generateRoute,
      theme: ThemeData(primarySwatch: Colors.green),
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
    context.read<PostsBloc>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: ViewStateBuilder<List<Post>, PostsBloc>(
        onLoading: (context) => const LoadingIndicator(),
        onSuccess: (context, posts) => PostsList(
          posts,
          onPostSelected: _navigateToPostDetails,
          onRefresh: context.read<PostsBloc>().refreshItems,
        ),
        onEmpty: (context) => const PostsListEmpty(),
      ),
    );
  }

  void _navigateToPostDetails(Post post) {
    Navigator.pushNamed(context, _Route.post, arguments: post.id);
  }
}

class PostDetailPage extends StatefulWidget {
  final int postId;

  const PostDetailPage(
    this.postId, {
    super.key,
  });

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostDetailsBloc>().loadItem(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: ViewStateListener<PostDetails, PostDetailsBloc>(
        onEmpty: _showSnackbarAndPopPage,
        child: ViewStateBuilder<PostDetails, PostDetailsBloc>(
          onLoading: (context) => const LoadingIndicator(),
          onSuccess: (context, post) => PostDetailsView(post),
          onError: (context, error) => ErrorMessage(error: error),
        ),
      ),
    );
  }

  void _showSnackbarAndPopPage(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          const SnackBar(
            content: Text('Post not found!'),
            duration: Duration(seconds: 2),
          ),
        )
        .closed
        .then((reason) => Navigator.pop(context));
  }
}

class PostDetailsView extends StatelessWidget {
  final PostDetails post;

  const PostDetailsView(
    this.post, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(post.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              post.body,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}

class _Route {
  static const String home = '/';
  static const String post = '/post';
}

// ignore: avoid_classes_with_only_static_members
class _Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case _Route.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PostsBloc(PostListRepository()),
            child: _PostsPage(),
          ),
        );
      case _Route.post:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PostDetailsBloc(PostDetailsRepository()),
            child: PostDetailPage(settings.arguments! as int),
          ),
        );
      default:
        throw Error();
    }
  }
}
