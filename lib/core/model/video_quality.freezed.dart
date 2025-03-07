// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_quality.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VideoQuality _$VideoQualityFromJson(Map<String, dynamic> json) {
  return _VideoQuality.fromJson(json);
}

/// @nodoc
mixin _$VideoQuality {
  String? get url => throw _privateConstructorUsedError;
  set url(String? value) => throw _privateConstructorUsedError;
  String? get quality => throw _privateConstructorUsedError;
  set quality(String? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VideoQualityCopyWith<VideoQuality> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoQualityCopyWith<$Res> {
  factory $VideoQualityCopyWith(
          VideoQuality value, $Res Function(VideoQuality) then) =
      _$VideoQualityCopyWithImpl<$Res, VideoQuality>;
  @useResult
  $Res call({String? url, String? quality});
}

/// @nodoc
class _$VideoQualityCopyWithImpl<$Res, $Val extends VideoQuality>
    implements $VideoQualityCopyWith<$Res> {
  _$VideoQualityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? quality = freezed,
  }) {
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      quality: freezed == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoQualityImplCopyWith<$Res>
    implements $VideoQualityCopyWith<$Res> {
  factory _$$VideoQualityImplCopyWith(
          _$VideoQualityImpl value, $Res Function(_$VideoQualityImpl) then) =
      __$$VideoQualityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url, String? quality});
}

/// @nodoc
class __$$VideoQualityImplCopyWithImpl<$Res>
    extends _$VideoQualityCopyWithImpl<$Res, _$VideoQualityImpl>
    implements _$$VideoQualityImplCopyWith<$Res> {
  __$$VideoQualityImplCopyWithImpl(
      _$VideoQualityImpl _value, $Res Function(_$VideoQualityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? quality = freezed,
  }) {
    return _then(_$VideoQualityImpl(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      quality: freezed == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoQualityImpl extends _VideoQuality {
  _$VideoQualityImpl({this.url, this.quality}) : super._();

  factory _$VideoQualityImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoQualityImplFromJson(json);

  @override
  String? url;
  @override
  String? quality;

  @override
  String toString() {
    return 'VideoQuality(url: $url, quality: $quality)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoQualityImplCopyWith<_$VideoQualityImpl> get copyWith =>
      __$$VideoQualityImplCopyWithImpl<_$VideoQualityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoQualityImplToJson(
      this,
    );
  }
}

abstract class _VideoQuality extends VideoQuality {
  factory _VideoQuality({String? url, String? quality}) = _$VideoQualityImpl;
  _VideoQuality._() : super._();

  factory _VideoQuality.fromJson(Map<String, dynamic> json) =
      _$VideoQualityImpl.fromJson;

  @override
  String? get url;
  set url(String? value);
  @override
  String? get quality;
  set quality(String? value);
  @override
  @JsonKey(ignore: true)
  _$$VideoQualityImplCopyWith<_$VideoQualityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
