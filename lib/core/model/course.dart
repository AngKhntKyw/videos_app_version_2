import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:videos_app_version_2/core/model/unit.dart';
part 'course.freezed.dart';
part 'course.g.dart';

@unfreezed
class Course with _$Course {
  const Course._();

  factory Course({
    required int id,
    required String title,
    required String description,
    required String imgUrl,
    required String introVideoUrl,
    required double price,
    required String outline,
    required List<Unit> units,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}
