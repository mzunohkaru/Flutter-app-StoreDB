import '../../model/entity/ranking/ranking_document.dart';
import '../../model/enum/country.dart';
import '../../model/enum/genre.dart';
import '../../model/type/app_id.dart';

  abstract class RankingRepository {
  Future<RankingDocument> fetchDoc({
    required Country country,
    required Genre genre,
    required AppID appId,
    required String date,
  });

  Future<List<RankingDocument>> fetchList({
    required Country country,
    required Genre genre,
    required AppID appId,
  });
}
