import 'package:example/src/post/model/post.dart';

class PostDetails extends Post {
  final String body;

  PostDetails({
    required int id,
    required String title,
    required this.body,
  }) : super(id: id, title: title);

  factory PostDetails.fromJson(dynamic json) {
    return PostDetails(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
