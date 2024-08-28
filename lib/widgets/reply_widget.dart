
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

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: replies.length,
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

