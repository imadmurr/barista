import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/favorites_repository.dart';
import 'auth_controller.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController(this._auth, this._repo) {
    _auth.addListener(_handleAuthChanged);
    _handleAuthChanged();
  }

  final AuthController _auth;
  final FavoritesRepository _repo;

  StreamSubscription<Set<String>>? _sub;
  Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  bool isFavorite(String id) => _favorites.contains(id);

  void _handleAuthChanged() {
    _sub?.cancel();
    _favorites = {};
    notifyListeners();

    final uid = _auth.uid;
    if (uid == null) return;

    _sub = _repo.watchFavoriteIds(uid).listen((favIds) {
      _favorites = favIds;
      notifyListeners();
    });
  }

  Future<void> toggle(String cocktailId) async {
    final uid = _auth.uid;
    if (uid == null) return;

    final currently = _favorites.contains(cocktailId);
    await _repo.toggleFavorite(
      uid: uid,
      cocktailId: cocktailId,
      isCurrentlyFavorite: currently,
    );
    // stream will update _favorites after write
  }

  @override
  void dispose() {
    _auth.removeListener(_handleAuthChanged);
    _sub?.cancel();
    super.dispose();
  }
}
