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
        onSuccess: (context, posts) => PostsList(
          posts,
          onPostSelected: _navigateToPostDetails,
          onRefresh: listBloc.refreshElements,
        ),
        onEmpty: (context) => const PostsListEmpty(),
      ),
    );
  }

  void _navigateToPostDetails(Post post) {
    Navigator.pushNamed(context, _Route.post, arguments: post.id);
  }

  @override
  void dispose() {
    listBloc.close();
    super.dispose();
  }
}

class _PostDetailPage extends StatefulWidget {
  final int postId;

  const _PostDetailPage(this.postId, {Key key}) : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<_PostDetailPage> {
  DetailsBloc<PostDetails, int> detailsBloc;

  @override
  void initState() {
    super.initState();
    detailsBloc = BlocProvider.of<DetailsBloc<PostDetails, int>>(context)
      ..loadElement(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: ViewStateBuilder<PostDetails, DetailsBloc<PostDetails, int>>(
        bloc: detailsBloc,
        onLoading: (context) => const LoadingIndicator(),
        onSuccess: (context, post) => _PostDetailsContent(post),
        onEmpty: _showSnackbarAndPopPage,
        onError: (context, error) => ErrorMessage(error: error),
      ),
    );
  }

  Widget _showSnackbarAndPopPage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context)
          .showSnackBar(
            const SnackBar(
              content: Text('Post not found!'),
              duration: Duration(seconds: 2),
            ),
          )
          .closed
          .then((reason) {
        Navigator.pop(context);
      });
    });
    return Container();
  }

  @override
  void dispose() {
    detailsBloc.close();
    super.dispose();
  }
}

class _PostDetailsContent extends StatelessWidget {
  final PostDetails post;

  const _PostDetailsContent(this.post, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(post.title, style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 8),
            Text(
              post.body,
              style: Theme.of(context).textTheme.bodyText2,
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

class _Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case _Route.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ListBloc<Post>(PostListRepository()),
            child: _PostsPage(),
          ),
        );
      case _Route.post:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DetailsBloc<PostDetails, int>(
              PostDetailsRepository(),
            ),
            child: _PostDetailPage(settings.arguments as int),
          ),
        );
      default:
        throw Error();
    }
  }
}
