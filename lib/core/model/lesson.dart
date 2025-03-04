import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:videos_app_version_2/core/model/download_model.dart';
part 'lesson.freezed.dart';
part 'lesson.g.dart';

@unfreezed
class Lesson with _$Lesson {
  const Lesson._();

  factory Lesson({
    required int id,
    required String title,
    required String description,
    String? lessonType,
    String? lessonUrl,
    DownloadModel? downloadModel,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}
