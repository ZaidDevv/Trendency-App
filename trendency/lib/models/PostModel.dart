import 'package:json_annotation/json_annotation.dart';
import 'package:trendency/models/RedditVideo.dart';
import 'package:trendency/models/SecureMedia.dart';

part 'PostModel.g.dart';

@JsonSerializable()
class PostModel {
  final String? subreddit;
  final String? title;
  final String? author;
  final int? num_comments;
  final int? created;
  final String? url;
  @JsonKey(name: "ups")
  final int? upvotes;
  final String? url_overriden_by_dest;
  final String? selftext;
  final String? post_type;
  final double? upvote_ratio;
  final String id;
  final SecureMedia? secure_media;

  final String thumbnail;

  PostModel({
    this.subreddit,
    this.title,
    this.author,
    this.num_comments,
    this.created,
    this.url_overriden_by_dest,
    this.upvote_ratio,
    this.secure_media,
    required this.id,
    this.url,
    this.post_type,
    required this.thumbnail,
    this.upvotes,
    this.selftext,
  });
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  // static DateTime _fromJson(int int) =>
  //     DateTime.fromMillisecondsSinceEpoch(int);
  // static int _toJson(DateTime time) => time.millisecondsSinceEpoch;
}
