import '../../model/entity/app_data/app_data_document.dart';
import '../../model/enum/firestore.dart';
import '../../model/type/app_id.dart';

abstract class AppDataRepository {
  Future<AppDataDocument> fetchDoc({
    required Country country,
    required Genre genre,
    required AppID appId,
  });

  Future<List<AppDataDocument>> fetchDocList({
    required Country country,
    required Genre genre,
  });
}
