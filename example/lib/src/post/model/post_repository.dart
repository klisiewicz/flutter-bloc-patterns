import 'dart:convert';
import 'dart:io';

import 'package:example/src/post/model/post.dart';
import 'package:example/src/post/model/post_details.dart';
import 'package:example/src/user/model/user.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/details.dart';
import 'package:flutter_bloc_patterns/filter_list.dart';
import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:http/http.dart' as http;

class PostListRepository implements ListRepository<Post> {
  @override
  Future<List<Post>> getAll() => _getPostsFromUrl();
}

class FilterPostRepository implements FilterListRepository<Post, User> {
  @override
  Future<List<Post>> getAll() => _getPostsFromUrl();

  @override
  Future<List<Post>> getBy(User user) {
    return _getPostsFromUrl(query: {'userId': user.id});
  }
}

class PagedPostRepository implements PagedListRepository<Post> {
  @override
  Future<List<Post>> getAll(Page page) {
    return _getPostsFromUrl(
      query: {
        '_start': '${page.offset}',
        '_limit': '${page.size}',
      },
    );
  }
}

class PostDetailsRepository implements DetailsRepository<PostDetails, int> {
  @override
  Future<PostDetails?> getById(int id) async {
    final uri = Uri(
      scheme: 'http',
      host: 'jsonplaceholder.typicode.com',
      path: 'posts/$id',
    );
    final response = await http.get(uri);
    if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to load post with id $id');
    }
    final postJson = json.decode(response.body) as Map;
    return PostDetails.fromJson(postJson);
  }
}

Future<List<Post>> _getPostsFromUrl({
  Map<String, dynamic>? query,
}) async {
  final uri = Uri(
    scheme: 'http',
    host: 'jsonplaceholder.typicode.com',
    path: 'posts',
    queryParameters: query,
  );
  final response = await http.get(uri);
  if (response.statusCode != HttpStatus.ok) {
    throw Exception('Failed to load post');
  }
  final dynamic postsJson = json.decode(response.body);
  if (postsJson is List) {
    final posts = postsJson.map((post) => Post.fromJson(post as Map)).toList();
    // Shuffle the list to achieve refresh impression
    return posts..shuffle();
  } else {
    return [];
  }
}
