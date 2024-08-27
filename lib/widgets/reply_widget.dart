import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vibestream/providers/reply_provider.dart';
import 'package:vibestream/widgets/video_player_widget.dart'; 
import 'package:provider/provider.dart';

class ReplyWidget extends StatefulWidget {
  final String postId;

  const ReplyWidget({required this.postId, Key? key}) : super(key: key);

  @override
  _ReplyWidgetState createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReplyProvider>(
      builder: (context, replyProvider, child) {
        if (!replyProvider.isLoading(widget.postId) &&
            replyProvider.getReplies(widget.postId).isEmpty) {
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
            final controller =
                VideoPlayerController.networkUrl(Uri.parse(reply.videoUrl));

            return FutureBuilder(
              future: controller.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  controller.play();
                  controller.setLooping(true);
                  return VideoPlayerWidget(
                    controller: controller,
                    showProgressIndicator:
                        true, 
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
