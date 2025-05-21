import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../exception/app_exception.dart';
import '../../model/entity/app_data/app_data.dart';
import '../../model/entity/app_data/app_data_document.dart';
import '../../model/enum/country.dart';
import '../../model/enum/genre.dart';
import '../../model/type/app_id.dart';
import '../base_repository.dart';
import 'app_data_repository.dart';

part 'app_data_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AppDataRepository appDataRepository(Ref ref) {
  return const AppDataRepositoryImpl();
}

class AppDataRepositoryImpl extends BaseRepository
    implements AppDataRepository {
  const AppDataRepositoryImpl();

  @override
  Future<AppDataDocument> fetchDoc({
    required Country country,
    required Genre genre,
    required AppID appId,
  }) async {
    return handleFirestoreOperation<AppDataDocument>(
      operation: () async {
        final snapshot = await AppDataDocument.documentReference(
          country: country,
          genre: genre,
          appId: appId,
        ).get();

        if (!snapshot.exists) {
          throw Exception('アプリデータが見つかりません');
        }

        return AppDataDocument(
          entity: AppData.fromJson(snapshot.data()!),
          ref: snapshot.reference,
        );
      },
      operationDescription: 'アプリデータを取得',
      notFoundErrorType: () =>
          const AppException.notFound(message: 'アプリデータが見つかりません'),
    );
  }

  @override
  Future<List<AppDataDocument>> fetchDocList({
    required Country country,
    required Genre genre,
  }) async {
    return handleFirestoreOperation<List<AppDataDocument>>(
      operation: () async {
        final snapshot = await AppDataDocument.collectionReference(
          country: country,
          genre: genre,
        ).get();

        if (snapshot.docs.isEmpty) {
          throw Exception('アプリデータが見つかりません');
        }

        return snapshot.docs
            .map((doc) => AppDataDocument(
                  entity: AppData.fromJson(doc.data()),
                  ref: doc.reference,
                ))
            .toList();
      },
      operationDescription: 'アプリデータを取得',
      notFoundErrorType: () =>
          const AppException.notFound(message: 'アプリデータが見つかりません'),
    );
  }
}
