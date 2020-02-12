class Post {
  final int id;
  final String title;

  Post({
    this.id,
    this.title,
  });

  factory Post.fromJson(dynamic json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}
