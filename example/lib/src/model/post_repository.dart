import 'dart:convert';
import 'dart:io';

import 'package:example/src/model/post.dart';
import 'package:example/src/model/post_details.dart';
import 'package:example/src/model/user.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/details.dart';
import 'package:flutter_bloc_patterns/filter_list.dart';
import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://jsonplaceholder.typicode.com/posts';

class PostRepository implements Repository<Post> {
  @override
  Future<List<Post>> getAll() => _getPostsFromUrl(baseUrl);
}

class FilterPostRepository implements FilterRepository<Post, User> {
  @override
  Future<List<Post>> getAll() => _getPostsFromUrl(baseUrl);

  @override
  Future<List<Post>> getBy(User user) {
    if (user == null || user.id == null)
      return _getPostsFromUrl(baseUrl);
    else
      return _getPostsFromUrl('$baseUrl?userId=${user.id}');
  }
}

class PagedPostRepository implements PagedRepository<Post> {
  @override
  Future<List<Post>> getAll(Page pageable) =>
      _getPostsFromUrl(
          '$baseUrl?_start=${pageable.offset}&_limit=${pageable.size}');
}

class PostDetailsRepository implements DetailsRepository<PostDetails, int> {
  @override
  Future<PostDetails> getById(int id) async {
    final response = await http.get('$baseUrl/$id');

    if (response.statusCode == HttpStatus.notFound)
      return null;
    else if (response.statusCode != HttpStatus.ok)
      throw Exception('Failed to load post with id $id');

    final dynamic postJson = json.decode(response.body);
    return PostDetails.fromJson(postJson);
  }
}

Future<List<Post>> _getPostsFromUrl(String url) async {
  final response = await http.get(url);

  if (response.statusCode != HttpStatus.ok)
    throw Exception('Failed to load post');

  final List<dynamic> postsJson = json.decode(response.body);
  final posts = postsJson.map((post) => Post.fromJson(post)).toList();
  // Shuffle the list to achieve refresh impression
  return posts..shuffle();
}
