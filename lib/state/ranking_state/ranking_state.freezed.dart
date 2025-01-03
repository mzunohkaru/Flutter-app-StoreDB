// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RankingState {
  List<RankingDocument> get rankingDocList =>
      throw _privateConstructorUsedError;
  AppException? get exception => throw _privateConstructorUsedError;

  /// Create a copy of RankingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RankingStateCopyWith<RankingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingStateCopyWith<$Res> {
  factory $RankingStateCopyWith(
          RankingState value, $Res Function(RankingState) then) =
      _$RankingStateCopyWithImpl<$Res, RankingState>;
  @useResult
  $Res call({List<RankingDocument> rankingDocList, AppException? exception});

  $AppExceptionCopyWith<$Res>? get exception;
}

/// @nodoc
class _$RankingStateCopyWithImpl<$Res, $Val extends RankingState>
    implements $RankingStateCopyWith<$Res> {
  _$RankingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RankingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rankingDocList = null,
    Object? exception = freezed,
  }) {
    return _then(_value.copyWith(
      rankingDocList: null == rankingDocList
          ? _value.rankingDocList
          : rankingDocList // ignore: cast_nullable_to_non_nullable
              as List<RankingDocument>,
      exception: freezed == exception
          ? _value.exception
          : exception // ignore: cast_nullable_to_non_nullable
              as AppException?,
    ) as $Val);
  }

  /// Create a copy of RankingState
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
abstract class _$$RankingStateImplCopyWith<$Res>
    implements $RankingStateCopyWith<$Res> {
  factory _$$RankingStateImplCopyWith(
          _$RankingStateImpl value, $Res Function(_$RankingStateImpl) then) =
      __$$RankingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RankingDocument> rankingDocList, AppException? exception});

  @override
  $AppExceptionCopyWith<$Res>? get exception;
}

/// @nodoc
class __$$RankingStateImplCopyWithImpl<$Res>
    extends _$RankingStateCopyWithImpl<$Res, _$RankingStateImpl>
    implements _$$RankingStateImplCopyWith<$Res> {
  __$$RankingStateImplCopyWithImpl(
      _$RankingStateImpl _value, $Res Function(_$RankingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RankingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rankingDocList = null,
    Object? exception = freezed,
  }) {
    return _then(_$RankingStateImpl(
      rankingDocList: null == rankingDocList
          ? _value._rankingDocList
          : rankingDocList // ignore: cast_nullable_to_non_nullable
              as List<RankingDocument>,
      exception: freezed == exception
          ? _value.exception
          : exception // ignore: cast_nullable_to_non_nullable
              as AppException?,
    ));
  }
}

/// @nodoc

class _$RankingStateImpl extends _RankingState {
  const _$RankingStateImpl(
      {required final List<RankingDocument> rankingDocList, this.exception})
      : _rankingDocList = rankingDocList,
        super._();

  final List<RankingDocument> _rankingDocList;
  @override
  List<RankingDocument> get rankingDocList {
    if (_rankingDocList is EqualUnmodifiableListView) return _rankingDocList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rankingDocList);
  }

  @override
  final AppException? exception;

  @override
  String toString() {
    return 'RankingState(rankingDocList: $rankingDocList, exception: $exception)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankingStateImpl &&
            const DeepCollectionEquality()
                .equals(other._rankingDocList, _rankingDocList) &&
            (identical(other.exception, exception) ||
                other.exception == exception));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_rankingDocList), exception);

  /// Create a copy of RankingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RankingStateImplCopyWith<_$RankingStateImpl> get copyWith =>
      __$$RankingStateImplCopyWithImpl<_$RankingStateImpl>(this, _$identity);
}

abstract class _RankingState extends RankingState {
  const factory _RankingState(
      {required final List<RankingDocument> rankingDocList,
      final AppException? exception}) = _$RankingStateImpl;
  const _RankingState._() : super._();

  @override
  List<RankingDocument> get rankingDocList;
  @override
  AppException? get exception;

  /// Create a copy of RankingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RankingStateImplCopyWith<_$RankingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
