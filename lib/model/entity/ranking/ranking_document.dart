import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/firestore/firestore_document.dart';
import '../../../services/firestore/firestore_service.dart';
import '../../enum/firestore.dart';
import 'ranking.dart';

class RankingDocument extends FirestoreDocument<Ranking> {
  RankingDocument({
    required this.entity,
    required this.ref,
  });

  @override
  final Ranking entity;

  @override
  final DocumentReference<Map<String, dynamic>> ref;

  static CollectionReference<Map<String, dynamic>> collectionReference({
    required Country country,
    required Genre genre,
    required String appId,
  }) =>
      FirestoreService()
          .firestore
          .collection("${country.name}")
          .doc("${Version.v1.name}")
          .collection("${genre.code}")
          .doc("${appId}")
          .collection("ranking");

  static DocumentReference<Map<String, dynamic>> documentReference({
    required Country country,
    required Genre genre,
    required String appId,
    required String date,
  }) =>
      collectionReference(
        country: country,
        genre: genre,
        appId: appId,
      ).doc("${date}");
}
