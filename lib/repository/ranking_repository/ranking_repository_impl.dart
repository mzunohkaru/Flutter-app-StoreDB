import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../exception/app_exception.dart';
import '../../model/entity/ranking/ranking.dart';
import '../../model/entity/ranking/ranking_document.dart';
import '../../model/enum/firestore.dart';
import '../../model/type/app_id.dart';
import '../base_repository.dart';
import 'ranking_repository.dart';

part 'ranking_repository_impl.g.dart';

@Riverpod(keepAlive: true)
RankingRepository rankingRepository(Ref ref) {
  return const RankingRepositoryImpl();
}

class RankingRepositoryImpl extends BaseRepository
    implements RankingRepository {
  const RankingRepositoryImpl();

  @override
  Future<RankingDocument> fetchDoc({
    required Country country,
    required Genre genre,
    required AppID appId,
    required String date,
  }) async {
    return handleFirestoreOperation<RankingDocument>(
      operation: () async {
        final snapshot = await RankingDocument.documentReference(
          country: country,
          genre: genre,
          appId: appId,
          date: date,
        ).get();

        if (!snapshot.exists) {
          throw Exception('ランキングが見つかりません');
        }

        return RankingDocument(
          entity: Ranking.fromJson(snapshot.data()!),
          ref: snapshot.reference,
        );
      },
      operationDescription: 'ランキングを取得',
      notFoundErrorType: () =>
          const AppException.notFound(message: 'ランキングが見つかりません'),
    );
  }

  @override
  Future<List<RankingDocument>> fetchList({
    required Country country,
    required Genre genre,
    required AppID appId,
  }) async {
    return handleFirestoreOperation<List<RankingDocument>>(
      operation: () async {
        final snapshot = await RankingDocument.collectionReference(
          country: country,
          genre: genre,
          appId: appId,
        ).get();

        if (snapshot.docs.isEmpty) {
          throw Exception('ランキングが見つかりません');
        }

        return snapshot.docs
            .map((doc) => RankingDocument(
                  entity: Ranking.fromJson(doc.data()),
                  ref: doc.reference,
                ))
            .toList();
      },
      operationDescription: 'ランキングを取得',
      notFoundErrorType: () =>
          const AppException.notFound(message: 'ランキングが見つかりません'),
    );
  }
}
