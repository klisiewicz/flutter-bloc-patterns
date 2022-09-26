import 'package:example/src/post/model/post.dart';

class PostDetails extends Post {
  final String body;

  PostDetails({
    required super.id,
    required super.title,
    required this.body,
  });

  factory PostDetails.fromJson(Map json) {
    return PostDetails(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
