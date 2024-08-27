import 'package:flutter/foundation.dart';
import 'package:vibestream/domain/models/reply.dart';
import 'package:vibestream/domain/services/api_service.dart';

class ReplyProvider with ChangeNotifier {
  final ApiService apiService;
  Map<String, List<Reply>> _replies = {};
  Map<String, bool> _isLoading = {};

  ReplyProvider(this.apiService);

  List<Reply> getReplies(String postId) {
    return _replies[postId] ?? [];
  }

  bool isLoading(String postId) {
    return _isLoading[postId] ?? false;
  }

  Future<void> loadReplies(String postId) async {
    _isLoading[postId] = true;
    notifyListeners();

    try {
      final replies = await apiService.fetchReplies(postId);
      _replies[postId] = replies;
    } catch (e) {
      _replies[postId] = [];
    } finally {
      _isLoading[postId] = false;
      notifyListeners();
    }
  }
}
