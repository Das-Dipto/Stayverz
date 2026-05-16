import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlayer extends StatefulWidget {
  final String videoId;
  const YouTubeVideoPlayer({super.key, required this.videoId});

  @override
  State<YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
        // forceHideAnnotation: true,
        useHybridComposition: true,
        isLive: false,
        disableDragSeek: false,
        loop: false,
        forceHD: false,
      //  enableJavaScript: true,
        controlsVisibleAtStart: true,
      ),
    );
    // _controller = YoutubePlayerController(
    //   initialVideoId: widget.videoId,
    //   flags: const YoutubePlayerFlags(
    //     autoPlay: false,
    //     mute: false,
    //     enableCaption: false,
    //   ),
    // );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Container(
          width: double.infinity,
          height: 250,
          child: player,
        );
      },
    );
  }
}

// Hello I am Tamim