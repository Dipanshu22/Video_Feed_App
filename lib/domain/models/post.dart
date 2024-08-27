class VideoPost {
  final int id;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final int childVideoCount;
  final String author;
  final String username;
  final DateTime createdAt;
  final String pictureUrl;

  VideoPost({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.childVideoCount,
    required this.author,
    required this.username,
    required this.createdAt,
    required this.pictureUrl,
  });

  factory VideoPost.fromJson(Map<String, dynamic> json) {
    return VideoPost(
      id: json['id'] as int,
      title: json['title'] as String,
      videoUrl: json['video_link'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      childVideoCount: json['child_video_count'] as int,
      author: '${json['first_name']} ${json['last_name']}',
      username: json['username'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      pictureUrl: json['picture_url'] as String,
    );
  }
}
