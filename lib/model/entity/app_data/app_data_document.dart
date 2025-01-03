import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/firestore/firestore_document.dart';
import '../../../services/firestore/firestore_service.dart';
import '../../enum/firestore.dart';
import '../../type/app_id.dart';
import 'app_data.dart';

class AppDataDocument extends FirestoreDocument<AppData> {
  AppDataDocument({
    required this.entity,
    required this.ref,
  });

  @override
  final AppData entity;

  @override
  final DocumentReference<Map<String, dynamic>> ref;

  static CollectionReference<Map<String, dynamic>> collectionReference({
    required Country country,
    required Genre genre,
  }) =>
      FirestoreService()
          .firestore
          .collection("${country.name}")
          .doc("${Version.v1.name}")
          .collection("${genre.code}");

  static DocumentReference<Map<String, dynamic>> documentReference({
    required Country country,
    required Genre genre,
    required AppID appId,
  }) =>
      collectionReference(
        country: country,
        genre: genre,
      ).doc("${appId}");
}
