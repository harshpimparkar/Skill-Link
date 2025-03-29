import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user {
    return _auth.authStateChanges().handleError((error) {
      debugPrint('AuthStateChanges error: $error');
      return null;
    });
  }

  User? get currentUser => _auth.currentUser;

  Future<void> clearAuthCache() async {
    await _auth.signOut();
    if (kIsWeb) {
      await _auth.setPersistence(Persistence.NONE);
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      debugPrint('Signed in user: ${result.user?.uid}');
      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('SignIn error: ${e.code}');
      throw handleAuthException(e);
    }
  }

  Future<User?> registerWithEmail(
      String email, String password, String username) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await _firestore.collection('users').doc(result.user?.uid).set({
        'email': email.trim(),
        'username': username.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    }
  }

  // Add method to get username
  Future<String?> getUsername(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      return null; // Or return a default value
    }
    return doc.data()?['username'] as String?;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Error handler (now public)
  String handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email already in use.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      default:
        return 'An error occurred.';
    }
  }
}
