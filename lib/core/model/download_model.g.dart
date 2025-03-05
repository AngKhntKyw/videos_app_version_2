// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DownloadModelImpl _$$DownloadModelImplFromJson(Map<String, dynamic> json) =>
    _$DownloadModelImpl(
      id: (json['id'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      lessonTitle: json['lessonTitle'] as String,
      url: json['url'] as String,
      path: json['path'] as String,
      progress: (json['progress'] as num).toDouble(),
      status: $enumDecodeNullable(_$DownloadStatusEnumMap, json['status']) ??
          DownloadStatus.none,
    );

Map<String, dynamic> _$$DownloadModelImplToJson(_$DownloadModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'lessonTitle': instance.lessonTitle,
      'url': instance.url,
      'path': instance.path,
      'progress': instance.progress,
      'status': _$DownloadStatusEnumMap[instance.status]!,
    };

const _$DownloadStatusEnumMap = {
  DownloadStatus.none: 'none',
  DownloadStatus.waiting: 'waiting',
  DownloadStatus.running: 'running',
  DownloadStatus.success: 'success',
  DownloadStatus.fail: 'fail',
};
