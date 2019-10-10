import 'package:example/src/common/error_message.dart';
import 'package:example/src/common/loading_indicator.dart';
import 'package:example/src/common/posts_list.dart';
import 'package:example/src/common/posts_list_empty.dart';
import 'package:example/src/model/post.dart';
import 'package:example/src/model/post_details.dart';
import 'package:example/src/model/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/details.dart';

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
      appBar: AppBar(title: Text('Posts')),
      body: ViewStateBuilder(
        bloc: listBloc,
        onLoading: (context) => LoadingIndicator(),
        onSuccess: (context, posts) =>
            PostsList(
              posts: posts,
              onPostSelected: _navigateToPostDetails,
              onRefresh: listBloc.refreshElements,
            ),
        onEmpty: (context) => PostsListEmpty(),
      ),
    );
  }

  void _navigateToPostDetails(Post post) {
    Navigator.pushNamed(context, _Route.post, arguments: post.id);
  }

  @override
  void dispose() {
    super.dispose();
    listBloc.dispose();
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
      appBar: AppBar(title: Text('Post')),
      body: ViewStateBuilder(
        bloc: detailsBloc,
        onLoading: (context) => LoadingIndicator(),
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
            SnackBar(
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
    super.dispose();
    detailsBloc.dispose();
  }
}

class _PostDetailsContent extends StatelessWidget {
  final PostDetails post;

  const _PostDetailsContent(this.post, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(post.title, style: Theme.of(context).textTheme.title),
            SizedBox(height: 8),
            Text(
              post.body,
              style: Theme.of(context).textTheme.body1,
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
            builder: (_) => ListBloc<Post>(PostRepository()),
            child: _PostsPage(),
          ),
        );
      case _Route.post:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            builder: (_) => DetailsBloc<PostDetails, int>(
              PostDetailsRepository(),
            ),
            child: _PostDetailPage(settings.arguments as int),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
