import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  factory FirestoreService() => _instance;

  FirestoreService._internal();
  static final FirestoreService _instance = FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;
}
