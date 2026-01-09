import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesRepository {
  FavoritesRepository._();
  static final instance = FavoritesRepository._();

  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _favCol(String uid) =>
      _db.collection('users').doc(uid).collection('favorites');

  Stream<Set<String>> watchFavoriteIds(String uid) {
    return _favCol(uid).snapshots().map((snap) {
      return snap.docs.map((d) => d.id).toSet();
    });
  }

  Future<void> toggleFavorite({
    required String uid,
    required String cocktailId,
    required bool isCurrentlyFavorite,
  }) async {
    final doc = _favCol(uid).doc(cocktailId);
    if (isCurrentlyFavorite) {
      await doc.delete();
    } else {
      await doc.set({
        'cocktailId': cocktailId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
