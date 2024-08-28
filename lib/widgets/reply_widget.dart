
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vibestream/providers/reply_provider.dart';
import 'package:vibestream/widgets/video_player_widget.dart'; 
import 'package:provider/provider.dart';

class ReplyWidget extends StatefulWidget {
  final String postId;
  final String originalTitle;
  final String originalThumbnailUrl;
  final String originalUsername;

  const ReplyWidget({
    required this.postId,
    required this.originalTitle,
    required this.originalThumbnailUrl,
    required this.originalUsername,
    Key? key,
  }) : super(key: key);

  @override
  _ReplyWidgetState createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  bool _showReferenceInfo = true; // State to control the visibility of the reference info
  PageController _pageController = PageController();
  int _currentReplyIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReplyProvider>(
      builder: (context, replyProvider, child) {
        if (!replyProvider.isLoading(widget.postId) && replyProvider.getReplies(widget.postId).isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            replyProvider.loadReplies(widget.postId);
          });
        }

        if (replyProvider.isLoading(widget.postId)) {
          return Center(child: CircularProgressIndicator());
        }

        final replies = replyProvider.getReplies(widget.postId);

        if (replies.isEmpty) {
          return Center(child: Text('No replies found'));
        }

        return Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: replies.length,
              onPageChanged: (index) {
                setState(() {
                  _currentReplyIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final reply = replies[index];
                final controller = VideoPlayerController.networkUrl(Uri.parse(reply.videoUrl));
                
                return FutureBuilder(
                  future: controller.initialize(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      controller.play();
                      controller.setLooping(true);
                      return Stack(
                        children: [
                          VideoPlayerWidget(
                            controller: controller, 
                            showProgressIndicator: true, // Enable progress indicator for replies
                          ),
                          if (_showReferenceInfo)
                            Positioned(
                              top: 20,
                              left: 10,
                              right: 10,
                              child: _ReferenceInfo(
                                title: widget.originalTitle,
                                thumbnailUrl: widget.originalThumbnailUrl,
                                username: widget.originalUsername,
                                onClose: () {
                                  setState(() {
                                    _showReferenceInfo = false;
                                  });
                                },
                              ),
                            ),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
            // Page indicators (only for the replies)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.45,
              right: 10,
              child: Column(
                children: [
                  for (int i = 0; i < replies.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          if (_currentReplyIndex == i)
                            Container(
                              width: 8,
                              height: 8,
                              decoration:const BoxDecoration(
                                color: Colors.grey, // Grey circle to the left
                                shape: BoxShape.circle,
                              ),
                            ),
                          const SizedBox(width: 4), // Space between grey and white circle
                          Container(
                            width: _currentReplyIndex == i ? 10 : 8,  // Adjust size based on current index
                            height: _currentReplyIndex == i ? 10 : 8, // Adjust size based on current index
                            decoration: BoxDecoration(
                              color: _currentReplyIndex == i ? Colors.white : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ReferenceInfo extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final String username;
  final VoidCallback onClose;

  const _ReferenceInfo({
    required this.title,
    required this.thumbnailUrl,
    required this.username,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              thumbnailUrl,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          // Reference text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Response to: ",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      username,
                      style:const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  title,
                  style:const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          // Close Button
          IconButton(
            icon: Icon(Icons.close, color: Colors.white70),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}






