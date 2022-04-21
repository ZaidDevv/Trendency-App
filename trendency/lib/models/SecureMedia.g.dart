// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SecureMedia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecureMedia _$SecureMediaFromJson(Map<String, dynamic> json) => SecureMedia(
      video: json['reddit_video'] == null
          ? null
          : RedditVideo.fromJson(json['reddit_video'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SecureMediaToJson(SecureMedia instance) =>
    <String, dynamic>{
      'reddit_video': instance.video,
    };
