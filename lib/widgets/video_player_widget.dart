import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final bool showProgressIndicator;

  const VideoPlayerWidget({
    required this.controller,
    this.showProgressIndicator = true,
    Key? key,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateState);
  }

  void _updateState() {
    if (mounted) {
      setState(() {});  // Forces a rebuild to update the timer
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.value.isInitialized
        ? GestureDetector(
            onTap: () {
              setState(() {
                if (_isPlaying) {
                  widget.controller.pause();
                } else {
                  widget.controller.play();
                }
                _isPlaying = !_isPlaying;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: widget.controller.value.size.width,
                      height: widget.controller.value.size.height,
                      child: VideoPlayer(widget.controller),
                    ),
                  ),
                ),
                if (!_isPlaying)
                  Icon(
                    Icons.play_arrow,
                    size: 100,
                    color: Colors.white.withOpacity(0.7),
                  ),
                if (widget.showProgressIndicator) ...[
                  Positioned(
                    bottom: 30, 
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            _formatDuration(widget.controller.value.position),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: VideoProgressIndicator(
                            widget.controller,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: Colors.amber,
                              backgroundColor: Colors.white.withOpacity(0.5),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            _formatDuration(widget.controller.value.duration),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}


















