import 'dart:convert';
import 'dart:io';

import 'package:example/src/album/model/album.dart';
import 'package:example/src/album/model/photo.dart';
import 'package:flutter_bloc_patterns/paged_filter_list.dart';
import 'package:http/http.dart' as http;

class PagedFilterPhotoRepository
    implements PagedListFilterRepository<Photo, Album> {
  @override
  Future<List<Photo>> getAll(Page page) async {
    final uri = _buildUri(page, null);
    return _getPhotosFrom(uri);
  }

  @override
  Future<List<Photo>> getBy(Page page, Album album) async {
    final uri = _buildUri(page, album);
    return _getPhotosFrom(uri);
  }

  Future<List<Photo>> _getPhotosFrom(Uri uri) async {
    final response = await http.get(uri);
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to load photos');
    }
    final dynamic postsJson = json.decode(response.body);
    return (postsJson is List)
        ? postsJson.map((photo) => Photo.fromJson(photo as Map)).toList()
        : [];
  }

  static Uri _buildUri(Page page, Album? album) {
    return Uri(
      scheme: 'http',
      host: 'jsonplaceholder.typicode.com',
      path: 'photos',
      queryParameters: {
        '_start': '${page.offset}',
        '_limit': '${page.size}',
        if (album != null) 'albumId': '${album.id}',
      },
    );
  }
}
