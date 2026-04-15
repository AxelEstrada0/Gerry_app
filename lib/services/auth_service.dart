import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/routes.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener usuario actual
  static User? get currentUser => _auth.currentUser;

  // Login
  static Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
  }

  // Registro
  static Future<void> register({
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  static Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  // Stream de estado
  static Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
