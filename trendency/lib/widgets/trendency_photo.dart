import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/widgets/trendency_app_bar.dart';

class TrendencyPhoto extends StatelessWidget {
  const TrendencyPhoto(
      {required this.url,
      this.backgroundDecoration,
      required this.title,
      this.minScale,
      this.maxScale});
  final String url;
  final String title;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          onTapUp: (_, __, ___) => Routemaster.of(context).pop(),
          onTapDown: (_, __, ___) => Routemaster.of(context).pop(),
          imageProvider: NetworkImage(url),
          backgroundDecoration: backgroundDecoration,
          minScale: minScale,
          maxScale: maxScale,
          filterQuality: FilterQuality.high,
          customSize: const Size(400, 350),
          heroAttributes: PhotoViewHeroAttributes(tag: title),
        ),
      ),
    );
  }
}
