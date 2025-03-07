// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_download.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VideoDownload _$VideoDownloadFromJson(Map<String, dynamic> json) {
  return _VideoDownload.fromJson(json);
}

/// @nodoc
mixin _$VideoDownload {
  String? get title => throw _privateConstructorUsedError;
  set title(String? value) => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  set source(String? value) => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  set thumbnail(String? value) => throw _privateConstructorUsedError;
  List<VideoQuality>? get videos => throw _privateConstructorUsedError;
  set videos(List<VideoQuality>? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VideoDownloadCopyWith<VideoDownload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoDownloadCopyWith<$Res> {
  factory $VideoDownloadCopyWith(
          VideoDownload value, $Res Function(VideoDownload) then) =
      _$VideoDownloadCopyWithImpl<$Res, VideoDownload>;
  @useResult
  $Res call(
      {String? title,
      String? source,
      String? thumbnail,
      List<VideoQuality>? videos});
}

/// @nodoc
class _$VideoDownloadCopyWithImpl<$Res, $Val extends VideoDownload>
    implements $VideoDownloadCopyWith<$Res> {
  _$VideoDownloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? source = freezed,
    Object? thumbnail = freezed,
    Object? videos = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      videos: freezed == videos
          ? _value.videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<VideoQuality>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoDownloadImplCopyWith<$Res>
    implements $VideoDownloadCopyWith<$Res> {
  factory _$$VideoDownloadImplCopyWith(
          _$VideoDownloadImpl value, $Res Function(_$VideoDownloadImpl) then) =
      __$$VideoDownloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? title,
      String? source,
      String? thumbnail,
      List<VideoQuality>? videos});
}

/// @nodoc
class __$$VideoDownloadImplCopyWithImpl<$Res>
    extends _$VideoDownloadCopyWithImpl<$Res, _$VideoDownloadImpl>
    implements _$$VideoDownloadImplCopyWith<$Res> {
  __$$VideoDownloadImplCopyWithImpl(
      _$VideoDownloadImpl _value, $Res Function(_$VideoDownloadImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? source = freezed,
    Object? thumbnail = freezed,
    Object? videos = freezed,
  }) {
    return _then(_$VideoDownloadImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      videos: freezed == videos
          ? _value.videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<VideoQuality>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoDownloadImpl extends _VideoDownload {
  _$VideoDownloadImpl({this.title, this.source, this.thumbnail, this.videos})
      : super._();

  factory _$VideoDownloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoDownloadImplFromJson(json);

  @override
  String? title;
  @override
  String? source;
  @override
  String? thumbnail;
  @override
  List<VideoQuality>? videos;

  @override
  String toString() {
    return 'VideoDownload(title: $title, source: $source, thumbnail: $thumbnail, videos: $videos)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoDownloadImplCopyWith<_$VideoDownloadImpl> get copyWith =>
      __$$VideoDownloadImplCopyWithImpl<_$VideoDownloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoDownloadImplToJson(
      this,
    );
  }
}

abstract class _VideoDownload extends VideoDownload {
  factory _VideoDownload(
      {String? title,
      String? source,
      String? thumbnail,
      List<VideoQuality>? videos}) = _$VideoDownloadImpl;
  _VideoDownload._() : super._();

  factory _VideoDownload.fromJson(Map<String, dynamic> json) =
      _$VideoDownloadImpl.fromJson;

  @override
  String? get title;
  set title(String? value);
  @override
  String? get source;
  set source(String? value);
  @override
  String? get thumbnail;
  set thumbnail(String? value);
  @override
  List<VideoQuality>? get videos;
  set videos(List<VideoQuality>? value);
  @override
  @JsonKey(ignore: true)
  _$$VideoDownloadImplCopyWith<_$VideoDownloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
