import 'package:flutter/foundation.dart';
import 'package:vibestream/domain/models/post.dart';
import 'package:vibestream/domain/services/api_service.dart';

class PostProvider with ChangeNotifier {
  final ApiService apiService;
  List<VideoPost> _posts = [];
  bool _isLoading = false;

  List<VideoPost> get posts => _posts;
  bool get isLoading => _isLoading;

  PostProvider(this.apiService);

  Future<void> loadFeed() async {
  _isLoading = true;
  notifyListeners();

  try {
    _posts = await apiService.fetchFeed();
    if (_posts.isNotEmpty) {
      print('Posts loaded successfully.');
    } else {
      print('No posts available after fetching.');
    }
  } catch (e) {
    print('Error loading posts: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
}
