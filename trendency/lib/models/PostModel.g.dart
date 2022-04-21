// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      subreddit: json['subreddit'] as String?,
      title: json['title'] as String?,
      author: json['author'] as String?,
      num_comments: json['num_comments'] as int?,
      created: json['created'] as int?,
      url_overriden_by_dest: json['url_overriden_by_dest'] as String?,
      upvote_ratio: (json['upvote_ratio'] as num?)?.toDouble(),
      secure_media: json['secure_media'] == null
          ? null
          : SecureMedia.fromJson(json['secure_media'] as Map<String, dynamic>),
      id: json['id'] as String,
      url: json['url'] as String?,
      post_type: json['post_type'] as String?,
      thumbnail: json['thumbnail'] as String,
      upvotes: json['ups'] as int?,
      selftext: json['selftext'] as String?,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'subreddit': instance.subreddit,
      'title': instance.title,
      'author': instance.author,
      'num_comments': instance.num_comments,
      'created': instance.created,
      'url': instance.url,
      'ups': instance.upvotes,
      'url_overriden_by_dest': instance.url_overriden_by_dest,
      'selftext': instance.selftext,
      'post_type': instance.post_type,
      'upvote_ratio': instance.upvote_ratio,
      'id': instance.id,
      'secure_media': instance.secure_media,
      'thumbnail': instance.thumbnail,
    };
