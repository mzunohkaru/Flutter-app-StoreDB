import 'package:cloud_firestore/cloud_firestore.dart';

import '../../exception/app_exception.dart';

/// リポジトリの基本クラス
///
/// このクラスは、Firestore操作の共通エラーハンドリングを提供します。
/// 全てのリポジトリ実装クラスはこのクラスを継承すべきです。
abstract class BaseRepository {
  const BaseRepository();

  /// Firestore操作を実行し、エラーハンドリングを行う
  ///
  /// [operation] 実行するFirestore操作
  /// [operationDescription] 操作の説明（エラーメッセージに使用）
  /// [notFoundErrorType] データが見つからない場合のエラータイプ
  /// [customErrorMessage] カスタムエラーメッセージを生成する関数（オプション）
  Future<T> handleFirestoreOperation<T>({
    required Future<T> Function() operation,
    required String operationDescription,
    required AppException Function() notFoundErrorType,
    String Function(Exception)? customErrorMessage,
  }) async {
    try {
      return await operation();
    } on FirebaseException catch (e) {
      throw AppException.firebase(
        e,
        message: customErrorMessage?.call(e) ??
            '$operationDescription時エラー: ${e.message}',
      );

      // TODO(aran): ネットワークのエラーを追加
    } on AppException {
      // AppExceptionの場合はそのまま再スロー
      rethrow;
    } on Exception catch (e) {
      // その他の例外はAppExceptionに変換してスロー
      if (customErrorMessage != null) {
        throw AppException.unknown(message: customErrorMessage(e));
      } else {
        throw notFoundErrorType();
      }
    }
  }

  /// Firestore操作を実行し、エラーハンドリングを行う（Stream）
  ///
  /// [operation] 実行するFirestore操作
  /// [operationDescription] 操作の説明（エラーメッセージに使用）
  /// [notFoundErrorType] データが見つからない場合のエラータイプ
  /// [customErrorMessage] カスタムエラーメッセージを生成する関数（オプション）
  Stream<T> handleFirestoreStreamOperation<T>({
    required Stream<T> Function() operation,
    required String operationDescription,
    required AppException Function() notFoundErrorType,
    String Function(Exception)? customErrorMessage,
  }) {
    return operation().handleError((Object e, StackTrace st) {
      if (e is FirebaseException) {
        throw AppException.firebase(
          e,
          message: customErrorMessage?.call(e) ??
              '$operationDescription時エラー: ${e.message}',
        );
      } else {
        if (customErrorMessage != null && e is Exception) {
          throw AppException.unknown(
            message: customErrorMessage(e),
          );
        } else {
          throw notFoundErrorType();
        }
      }
    });
  }
}
