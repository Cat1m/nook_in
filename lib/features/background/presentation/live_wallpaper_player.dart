import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LiveWallpaperPlayer extends StatefulWidget {
  final String assetPath;

  const LiveWallpaperPlayer({super.key, required this.assetPath});

  @override
  State<LiveWallpaperPlayer> createState() => _LiveWallpaperPlayerState();
}

class _LiveWallpaperPlayerState extends State<LiveWallpaperPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  // Khi assetPath thay đổi (chuyển video khác), widget này được update
  @override
  void didUpdateWidget(covariant LiveWallpaperPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _controller.dispose();
      _initializeVideo();
    }
  }

  void _initializeVideo() {
    // Init từ asset
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) {
        // Init xong thì chạy
        _controller.setVolume(0); // Bắt buộc mute để ko đá nhau với Mixer
        _controller.setLooping(true); // Loop vô tận
        _controller.play();
        setState(() {}); // Rebuild để hiện video
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container(color: Colors.black); // Màn hình đen lúc load
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover, // Zoom video full màn hình
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
