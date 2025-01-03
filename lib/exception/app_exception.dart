import 'package:firebase_core/firebase_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

@freezed
class AppException with _$AppException implements Exception {
  const AppException._();
  const factory AppException.network({
    @Default('ネットワークエラーが発生しました') String message,
  }) = _Network;

  const factory AppException.notFound({
    @Default('リソースが見つかりません') String message,
  }) = _NotFound;

  const factory AppException.unauthorized({
    @Default('認証されていません') String message,
  }) = _Unauthorized;

  const factory AppException.unknown({
    @Default('不明なエラーが発生しました') String message,
  }) = _Unknown;

  const factory AppException.firebase(
    FirebaseException firebaseException, {
    @Default('サーバーの発生しました') String message,
  }) = _Firebase;

  String get errorMessage => when(
        network: (message) => message,
        notFound: (message) => message,
        unauthorized: (message) => message,
        unknown: (message) => message,
        firebase: (_, message) => message,
      );
}
