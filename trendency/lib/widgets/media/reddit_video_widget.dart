import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:video_player/video_player.dart';

class RedditVideoWidget extends StatefulWidget {
  const RedditVideoWidget(
      {Key? key,
      required this.url,
      required this.looping,
      required this.controller,
      required this.autoplay})
      : super(key: key);

  final VideoPlayerController controller;
  final bool looping;
  final bool autoplay;
  final String url;
  @override
  State<RedditVideoWidget> createState() => _RedditVideoWidgetState();
}

class _RedditVideoWidgetState extends State<RedditVideoWidget> {
  late ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      hideControlsTimer: Duration(milliseconds: 750),
      aspectRatio: widget.controller.value.aspectRatio,
      autoInitialize: true,
      showControlsOnInitialize: false,
      placeholder: Center(
          child: SpinKitFadingCircle(
        color: AppColor.primary,
      )),
      materialProgressColors: ChewieProgressColors(
          backgroundColor: AppColor.primary,
          bufferedColor: AppColor.secondaryColor,
          handleColor: AppColor.thirdColor,
          playedColor: AppColor.thirdColor),
      videoPlayerController: widget.controller,
      autoPlay: widget.autoplay,
      looping: widget.looping,
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 370,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}
