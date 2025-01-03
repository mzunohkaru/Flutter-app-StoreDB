// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_data_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppDataState {
  List<AppDataDocument> get appDataDocList =>
      throw _privateConstructorUsedError;
  AppException? get exception => throw _privateConstructorUsedError;

  /// Create a copy of AppDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppDataStateCopyWith<AppDataState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppDataStateCopyWith<$Res> {
  factory $AppDataStateCopyWith(
          AppDataState value, $Res Function(AppDataState) then) =
      _$AppDataStateCopyWithImpl<$Res, AppDataState>;
  @useResult
  $Res call({List<AppDataDocument> appDataDocList, AppException? exception});

  $AppExceptionCopyWith<$Res>? get exception;
}

/// @nodoc
class _$AppDataStateCopyWithImpl<$Res, $Val extends AppDataState>
    implements $AppDataStateCopyWith<$Res> {
  _$AppDataStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppDataState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appDataDocList = null,
    Object? exception = freezed,
  }) {
    return _then(_value.copyWith(
      appDataDocList: null == appDataDocList
          ? _value.appDataDocList
          : appDataDocList // ignore: cast_nullable_to_non_nullable
              as List<AppDataDocument>,
      exception: freezed == exception
          ? _value.exception
          : exception // ignore: cast_nullable_to_non_nullable
              as AppException?,
    ) as $Val);
  }

  /// Create a copy of AppDataState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppExceptionCopyWith<$Res>? get exception {
    if (_value.exception == null) {
      return null;
    }

    return $AppExceptionCopyWith<$Res>(_value.exception!, (value) {
      return _then(_value.copyWith(exception: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppDataStateImplCopyWith<$Res>
    implements $AppDataStateCopyWith<$Res> {
  factory _$$AppDataStateImplCopyWith(
          _$AppDataStateImpl value, $Res Function(_$AppDataStateImpl) then) =
      __$$AppDataStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<AppDataDocument> appDataDocList, AppException? exception});

  @override
  $AppExceptionCopyWith<$Res>? get exception;
}

/// @nodoc
class __$$AppDataStateImplCopyWithImpl<$Res>
    extends _$AppDataStateCopyWithImpl<$Res, _$AppDataStateImpl>
    implements _$$AppDataStateImplCopyWith<$Res> {
  __$$AppDataStateImplCopyWithImpl(
      _$AppDataStateImpl _value, $Res Function(_$AppDataStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppDataState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appDataDocList = null,
    Object? exception = freezed,
  }) {
    return _then(_$AppDataStateImpl(
      appDataDocList: null == appDataDocList
          ? _value._appDataDocList
          : appDataDocList // ignore: cast_nullable_to_non_nullable
              as List<AppDataDocument>,
      exception: freezed == exception
          ? _value.exception
          : exception // ignore: cast_nullable_to_non_nullable
              as AppException?,
    ));
  }
}

/// @nodoc

class _$AppDataStateImpl extends _AppDataState {
  const _$AppDataStateImpl(
      {required final List<AppDataDocument> appDataDocList, this.exception})
      : _appDataDocList = appDataDocList,
        super._();

  final List<AppDataDocument> _appDataDocList;
  @override
  List<AppDataDocument> get appDataDocList {
    if (_appDataDocList is EqualUnmodifiableListView) return _appDataDocList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appDataDocList);
  }

  @override
  final AppException? exception;

  @override
  String toString() {
    return 'AppDataState(appDataDocList: $appDataDocList, exception: $exception)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppDataStateImpl &&
            const DeepCollectionEquality()
                .equals(other._appDataDocList, _appDataDocList) &&
            (identical(other.exception, exception) ||
                other.exception == exception));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_appDataDocList), exception);

  /// Create a copy of AppDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppDataStateImplCopyWith<_$AppDataStateImpl> get copyWith =>
      __$$AppDataStateImplCopyWithImpl<_$AppDataStateImpl>(this, _$identity);
}

abstract class _AppDataState extends AppDataState {
  const factory _AppDataState(
      {required final List<AppDataDocument> appDataDocList,
      final AppException? exception}) = _$AppDataStateImpl;
  const _AppDataState._() : super._();

  @override
  List<AppDataDocument> get appDataDocList;
  @override
  AppException? get exception;

  /// Create a copy of AppDataState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppDataStateImplCopyWith<_$AppDataStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
