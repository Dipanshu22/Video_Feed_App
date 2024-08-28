
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibestream/providers/post_provider.dart';
import 'package:vibestream/widgets/post_widget.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Defer the loadFeed call to ensure it happens after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).loadFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (postProvider.posts.isEmpty) {
            return Center(child: Text('No posts available.'));
          }

          return PageView.builder(
            scrollDirection: Axis.vertical, // Vertical scroll
            itemCount: postProvider.posts.length,
            itemBuilder: (context, index) {
              final post = postProvider.posts[index];
              final hasReplies = post.childVideoCount > 0;

              return PostWidget(
                post: post,
                totalPosts: postProvider.posts.length,
                currentIndex: index,
                hasReplies: hasReplies,
                originalTitle: post.title,
                originalThumbnailUrl: post.thumbnailUrl,
                originalUsername: post.username,
              );
            },
          );
        },
      ),
    );
  }
}







