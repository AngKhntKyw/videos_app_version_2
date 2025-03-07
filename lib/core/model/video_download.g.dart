// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_download.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoDownloadImpl _$$VideoDownloadImplFromJson(Map<String, dynamic> json) =>
    _$VideoDownloadImpl(
      title: json['title'] as String?,
      source: json['source'] as String?,
      thumbnail: json['thumbnail'] as String?,
      videos: (json['videos'] as List<dynamic>?)
          ?.map((e) => VideoQuality.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$VideoDownloadImplToJson(_$VideoDownloadImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'source': instance.source,
      'thumbnail': instance.thumbnail,
      'videos': instance.videos,
    };
