import 'package:flutter/foundation.dart';

@immutable
class Album {
  final int id;
  final String? title;

  const Album({
    required this.id,
    this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as int,
      title: json['title'] as String?,
    );
  }
}
