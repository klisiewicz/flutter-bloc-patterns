import 'dart:convert';
import 'dart:io';

import 'package:example/src/common/url.dart';
import 'package:example/src/post/model/post.dart';
import 'package:example/src/post/model/post_details.dart';
import 'package:example/src/user/model/user.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/details.dart';
import 'package:flutter_bloc_patterns/filter_list.dart';
import 'package:flutter_bloc_patterns/paged_filter_list.dart';
import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:http/http.dart' as http;

const _postsUrl = '$baseUrl/posts';

class PostListRepository implements ListRepository<Post> {
  @override
  Future<List<Post>> getAll() => _getPostsFromUrl(_postsUrl);
}

class FilterPostRepository implements FilterListRepository<Post, User> {
  @override
  Future<List<Post>> getAll() => _getPostsFromUrl(_postsUrl);

  @override
  Future<List<Post>> getBy(User user) {
    if (user == null || user.id == null)
      return _getPostsFromUrl(_postsUrl);
    else
      return _getPostsFromUrl('$_postsUrl?userId=${user.id}');
  }
}

class PagedPostRepository implements PagedListRepository<Post> {
  @override
  Future<List<Post>> getAll(Page page) =>
      _getPostsFromUrl('$_postsUrl?_start=${page.offset}&_limit=${page.size}');
}

class PostDetailsRepository implements DetailsRepository<PostDetails, int> {
  @override
  Future<PostDetails> getById(int id) async {
    final response = await http.get('$_postsUrl/$id');

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
