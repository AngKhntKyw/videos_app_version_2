import 'package:freezed_annotation/freezed_annotation.dart';
part 'video_quality.freezed.dart';
part 'video_quality.g.dart';

@unfreezed
class VideoQuality with _$VideoQuality {
  const VideoQuality._();

  factory VideoQuality({
    String? url,
    String? quality,
  }) = _VideoQuality;

  factory VideoQuality.fromJson(Map<String, dynamic> json) =>
      _$VideoQualityFromJson(json);
}
