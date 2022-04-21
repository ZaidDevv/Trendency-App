import 'package:json_annotation/json_annotation.dart';
import 'package:trendency/models/RedditVideo.dart';

part 'SecureMedia.g.dart';

@JsonSerializable()
class SecureMedia {
  @JsonKey(name: "reddit_video")
  final RedditVideo? video;

  SecureMedia({this.video});
  factory SecureMedia.fromJson(Map<String, dynamic> json) =>
      _$SecureMediaFromJson(json);

  Map<String, dynamic> toJson() => _$SecureMediaToJson(this);
}
