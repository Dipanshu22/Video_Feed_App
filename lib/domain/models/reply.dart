class Reply {
  final int id;
  final String title;
  final String videoUrl; 
  final String thumbnailUrl; 
  final int childVideoCount; 
  final String author; 
  final String username; 
  final DateTime createdAt; 
  final String pictureUrl;

  Reply({
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

  // Factory constructor for creating a new Reply instance from a JSON map
  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
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

  // Method to convert Reply instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'video_link': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'child_video_count': childVideoCount,
      'first_name': author.split(' ')[0], 
      'last_name': author.split(' ')[1],
      'username': username,
      'created_at': createdAt.millisecondsSinceEpoch,
      'picture_url': pictureUrl,
    };
  }
}
