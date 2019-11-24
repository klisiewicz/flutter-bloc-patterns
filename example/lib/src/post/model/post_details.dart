import 'package:example/src/post/model/post.dart';

class PostDetails extends Post {
  final String body;

  PostDetails({
    int id,
    String title,
    this.body,
  }) : super(
          id: id,
          title: title,
        );

  factory PostDetails.fromJson(Map<String, dynamic> json) {
    return PostDetails(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
