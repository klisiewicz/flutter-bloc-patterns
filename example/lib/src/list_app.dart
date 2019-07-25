import 'dart:convert';
import 'dart:io';

import 'package:example/src/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:http/http.dart' as http;

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
        child: PostsPage(),
      ),
    );
  }
}

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
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
          onLoading: _buildProgress,
          onResult: _buildPostsList,
          onNoResult: _buildNoPosts,
          onError: _buildErrorMessage,
        ).build,
      ),
    );
  }

  Widget _buildProgress(BuildContext context) =>
      Center(child: CircularProgressIndicator());

  Widget _buildPostsList(BuildContext context, List<Post> posts) =>
      ListView.separated(
        itemCount: posts.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(posts[index].title),
          subtitle: Text(posts[index].body),
        ),
        separatorBuilder: (context, index) => Divider(height: 1),
      );

  Widget _buildNoPosts(BuildContext context) =>
      Center(child: Text('No posts found'));

  Widget _buildErrorMessage(BuildContext context, Exception error) =>
      Center(child: Text(error.toString()));
}

class PostRepository implements Repository<Post> {
  @override
  Future<List<Post>> getAll() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/posts/');

    if (response.statusCode != HttpStatus.ok)
      throw Exception('Failed to load post');

    final List<dynamic> posts = json.decode(response.body);
    return posts.map((post) => Post.fromJson(post)).toList();
  }
}
