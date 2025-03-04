// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DownloadModel _$DownloadModelFromJson(Map<String, dynamic> json) {
  return _DownloadModel.fromJson(json);
}

/// @nodoc
mixin _$DownloadModel {
  int get id => throw _privateConstructorUsedError;
  set id(int value) => throw _privateConstructorUsedError;
  int get courseId => throw _privateConstructorUsedError;
  set courseId(int value) => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  set url(String value) => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  set path(String value) => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  set progress(double value) => throw _privateConstructorUsedError;
  DownloadStatus get status => throw _privateConstructorUsedError;
  set status(DownloadStatus value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DownloadModelCopyWith<DownloadModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadModelCopyWith<$Res> {
  factory $DownloadModelCopyWith(
          DownloadModel value, $Res Function(DownloadModel) then) =
      _$DownloadModelCopyWithImpl<$Res, DownloadModel>;
  @useResult
  $Res call(
      {int id,
      int courseId,
      String url,
      String path,
      double progress,
      DownloadStatus status});
}

/// @nodoc
class _$DownloadModelCopyWithImpl<$Res, $Val extends DownloadModel>
    implements $DownloadModelCopyWith<$Res> {
  _$DownloadModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? url = null,
    Object? path = null,
    Object? progress = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      courseId: null == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DownloadStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DownloadModelImplCopyWith<$Res>
    implements $DownloadModelCopyWith<$Res> {
  factory _$$DownloadModelImplCopyWith(
          _$DownloadModelImpl value, $Res Function(_$DownloadModelImpl) then) =
      __$$DownloadModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int courseId,
      String url,
      String path,
      double progress,
      DownloadStatus status});
}

/// @nodoc
class __$$DownloadModelImplCopyWithImpl<$Res>
    extends _$DownloadModelCopyWithImpl<$Res, _$DownloadModelImpl>
    implements _$$DownloadModelImplCopyWith<$Res> {
  __$$DownloadModelImplCopyWithImpl(
      _$DownloadModelImpl _value, $Res Function(_$DownloadModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? url = null,
    Object? path = null,
    Object? progress = null,
    Object? status = null,
  }) {
    return _then(_$DownloadModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      courseId: null == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DownloadStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DownloadModelImpl extends _DownloadModel {
  _$DownloadModelImpl(
      {required this.id,
      required this.courseId,
      required this.url,
      required this.path,
      required this.progress,
      this.status = DownloadStatus.none})
      : super._();

  factory _$DownloadModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DownloadModelImplFromJson(json);

  @override
  int id;
  @override
  int courseId;
  @override
  String url;
  @override
  String path;
  @override
  double progress;
  @override
  @JsonKey()
  DownloadStatus status;

  @override
  String toString() {
    return 'DownloadModel(id: $id, courseId: $courseId, url: $url, path: $path, progress: $progress, status: $status)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadModelImplCopyWith<_$DownloadModelImpl> get copyWith =>
      __$$DownloadModelImplCopyWithImpl<_$DownloadModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DownloadModelImplToJson(
      this,
    );
  }
}

abstract class _DownloadModel extends DownloadModel {
  factory _DownloadModel(
      {required int id,
      required int courseId,
      required String url,
      required String path,
      required double progress,
      DownloadStatus status}) = _$DownloadModelImpl;
  _DownloadModel._() : super._();

  factory _DownloadModel.fromJson(Map<String, dynamic> json) =
      _$DownloadModelImpl.fromJson;

  @override
  int get id;
  set id(int value);
  @override
  int get courseId;
  set courseId(int value);
  @override
  String get url;
  set url(String value);
  @override
  String get path;
  set path(String value);
  @override
  double get progress;
  set progress(double value);
  @override
  DownloadStatus get status;
  set status(DownloadStatus value);
  @override
  @JsonKey(ignore: true)
  _$$DownloadModelImplCopyWith<_$DownloadModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
