import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:videos_app_version_2/core/enum/download_status.dart';
part 'download_model.freezed.dart';
part 'download_model.g.dart';

@unfreezed
class DownloadModel with _$DownloadModel {
  const DownloadModel._();

  factory DownloadModel({
    required int id,
    required int courseId,
    required String lessonTitle,
    required String url,
    required String path,
    required double progress,
    @Default(DownloadStatus.none) DownloadStatus status,
  }) = _DownloadModel;

  factory DownloadModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadModelFromJson(json);
}
