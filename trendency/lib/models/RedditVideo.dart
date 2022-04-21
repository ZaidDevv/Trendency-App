import 'package:json_annotation/json_annotation.dart';

part 'RedditVideo.g.dart';

@JsonSerializable()
class RedditVideo {
  final String fallback_url;
  final int duration;
  final bool is_gif;
  final int width;
  final int height;

  RedditVideo(
      {required this.fallback_url,
      required this.duration,
      required this.is_gif,
      required this.height,
      required this.width});
  factory RedditVideo.fromJson(Map<String, dynamic> json) =>
      _$RedditVideoFromJson(json);

  Map<String, dynamic> toJson() => _$RedditVideoToJson(this);
}
