class Post {
  final int id;
  final String title;

  Post({
    required this.id,
    required this.title,
  });

  factory Post.fromJson(Map json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}
