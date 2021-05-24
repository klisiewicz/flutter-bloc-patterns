import 'dart:convert';
import 'dart:io';

import 'package:example/src/album/model/album.dart';
import 'package:example/src/album/model/photo.dart';
import 'package:example/src/common/url.dart';
import 'package:flutter_bloc_patterns/page.dart';
import 'package:flutter_bloc_patterns/paged_filter_list.dart';
import 'package:http/http.dart' as http;

class PagedFilterPhotoRepository
    implements PagedListFilterRepository<Photo, Album> {
  static const _photosUrl = '$baseUrl/photos';

  @override
  Future<List<Photo>> getAll(Page page) => getBy(page, null);

  @override
  Future<List<Photo>> getBy(Page page, Album album) async {
    final response = await http.get(_buildUri(page, album));

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to load photos');
    }

    final dynamic postsJson = json.decode(response.body);
    return (postsJson is List)
        ? postsJson.map((photo) => Photo.fromJson(photo)).toList()
        : [];
  }

  Uri _buildUri(Page page, Album album) {
    final pageQuery = '_start=${page.offset}&_limit=${page.size}';
    final userQuery = (album != null) ? 'albumId=${album.id}' : null;
    final query = pageQuery + (userQuery != null ? '&$userQuery' : '');
    return UriData.fromString('$_photosUrl/?$query').uri;
  }
}
