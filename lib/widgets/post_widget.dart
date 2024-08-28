
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vibestream/domain/models/post.dart';
import 'package:vibestream/widgets/video_player_widget.dart';
import 'package:vibestream/widgets/reply_widget.dart';

class PostWidget extends StatefulWidget {
  final VideoPost post;

  const PostWidget({required this.post, Key? key}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late VideoPlayerController _controller;
  bool _isControllerDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.post.videoUrl))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isControllerDisposed = false;
        });
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void deactivate() {
    if (!_isControllerDisposed) {
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _isControllerDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          scrollDirection: Axis.horizontal,
          children: [
            // Main video page
            Stack(
              children: [
                Positioned.fill(
                  child: _isControllerDisposed
                      ? Container(color: Colors.black)
                      : VideoPlayerWidget(controller: _controller),
                ),
                // Video progress bar (only on the main video screen)
                Positioned(
                  bottom: 50, // Adjust to position it directly above the bottom navigation bar
                  left: 0,
                  right: 0,
                  child: _isControllerDisposed
                      ? Container()
                      : VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: Colors.amber,
                            backgroundColor: Colors.white.withOpacity(0.5),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                ),
                // Bottom navigation bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _BottomAppNavigator(),
                ),
              ],
            ),
            // Replies horizontal scroll, no progress indicator
            ReplyWidget(
              postId: widget.post.id.toString(),
              originalTitle: widget.post.title,
              originalThumbnailUrl: widget.post.thumbnailUrl,
              originalUsername: widget.post.username, // Pass the username
            ),
          ],
        ),
        // Video title and author information
        Positioned(
          bottom: 100, // Just above the bottom navigation bar
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.title,
                style:const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.post.author,
                style:const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        // Video controls (like, comment, share)
        Positioned(
          bottom: 100, // Align with the title and author information
          right: 20,
          child: Column(
            children: [
              IconButton(
                icon:const Icon(Icons.favorite, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon:const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon:const Icon(Icons.fullscreen, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon:const Icon(Icons.ondemand_video, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _BottomAppNavigator() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon:const Icon(Icons.home, color: Colors.amber),
            onPressed: () {},
          ),
          IconButton(
            icon:const Icon(Icons.ondemand_video, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon:const Icon(Icons.camera_alt, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon:const Icon(Icons.person, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}



























