import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final Key key; // Add this line
  VideoPlayerWidget({required this.videoUrl, required this.key}); //
  static _VideoPlayerWidgetState? of(BuildContext context) =>
      context.findAncestorStateOfType<_VideoPlayerWidgetState>();
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}
class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false, 
      looping: false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}