import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../data/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repo) {
    _sub = _repo.authStateChanges().listen((u) {
      _user = u;
      _isInitialized = true;
      notifyListeners();
    });
  }

  final AuthRepository _repo;
  StreamSubscription<User?>? _sub;

  User? _user;
  bool _isInitialized = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  String? get uid => _user?.uid;

  Future<void> signIn(String email, String password) {
    return _repo.signIn(email: email, password: password);
  }

  Future<void> signUp(String email, String password) {
    return _repo.signUp(email: email, password: password);
  }

  Future<void> signOut() => _repo.signOut();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
