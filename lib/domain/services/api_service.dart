import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vibestream/domain/models/post.dart';
import 'package:vibestream/domain/models/reply.dart';

class ApiService {
  final String feedUrl = 'https://api.wemotions.app/feed?page=1';
  final String repliesUrlTemplate = 'https://api.wemotions.app/posts/{id}/replies';

 Future<List<VideoPost>> fetchFeed() async {
  try {
    print('Fetching feed from $feedUrl');
    final response = await http.get(Uri.parse(feedUrl));
    print('Response status code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> postsJson = data['posts'];
      print('Number of posts fetched: ${postsJson.length}');
      return postsJson.map((json) => VideoPost.fromJson(json)).toList();
    } else {
      print('Failed to load feed, status code: ${response.statusCode}');
      throw Exception('Failed to load feed');
    }
  } catch (e) {
    print('Exception occurred while fetching feed: $e');
    return [];
  }
}



  Future<List<Reply>> fetchReplies(String postId) async {
    final repliesUrl = repliesUrlTemplate.replaceFirst('{id}', postId);
    try {
      final response = await http.get(Uri.parse(repliesUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> repliesJson = data['post'];
        return repliesJson.map((json) => Reply.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load replies');
      }
    } catch (e) {
      throw Exception('Failed to fetch replies: $e');
    }
  }
}
