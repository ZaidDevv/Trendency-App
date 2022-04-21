// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RedditVideo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedditVideo _$RedditVideoFromJson(Map<String, dynamic> json) => RedditVideo(
      fallback_url: json['fallback_url'] as String,
      duration: json['duration'] as int,
      is_gif: json['is_gif'] as bool,
      height: json['height'] as int,
      width: json['width'] as int,
    );

Map<String, dynamic> _$RedditVideoToJson(RedditVideo instance) =>
    <String, dynamic>{
      'fallback_url': instance.fallback_url,
      'duration': instance.duration,
      'is_gif': instance.is_gif,
      'width': instance.width,
      'height': instance.height,
    };
