import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:videos_app_version_2/core/model/video_quality.dart';
part 'video_download.freezed.dart';
part 'video_download.g.dart';

@unfreezed
class VideoDownload with _$VideoDownload {
  const VideoDownload._();

  factory VideoDownload({
    String? title,
    String? source,
    String? thumbnail,
    List<VideoQuality>? videos,
  }) = _VideoDownload;

  factory VideoDownload.fromJson(Map<String, dynamic> json) =>
      _$VideoDownloadFromJson(json);
}
