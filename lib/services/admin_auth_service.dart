import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/firebase_config.dart';

class AdminAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserCredential?> secureAdminLogin(
      String email,
      String password,
      ) async {
    try {
      // Pre-validation
      if (!FirebaseConfig.isAdmin(email)) {
        throw Exception('Unauthorized admin access attempt');
      }

      // Rate limiting check
      await _checkRateLimit(email);

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Additional security: Check email verification
      if (!userCredential.user!.emailVerified) {
        await _auth.signOut();
        throw Exception('Email verification required for admin access');
      }

      return userCredential;
    } catch (e) {
      print('Secure Admin Login Error: $e');
      return null;
    }
  }

  static Future<void> _checkRateLimit(String email) async {
    // Implement rate limiting logic here
    // You can use Firebase Firestore to track login attempts
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Enhanced rate limiting with Firebase tracking
  static Future<void> _checkEnhancedRateLimit(String email) async {
    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();
    final fiveMinutesAgo = now.subtract(const Duration(minutes: 5));

    // Check login attempts in last 5 minutes
    final attemptsRef = firestore
        .collection('login_attempts')
        .doc(email)
        .collection('attempts')
        .where('timestamp', isGreaterThan: fiveMinutesAgo);

    final snapshot = await attemptsRef.get();

    if (snapshot.docs.length >= 5) { // Max 5 attempts in 5 minutes
      throw Exception('Too many login attempts. Please try again later.');
    }

    // Record this attempt
    await firestore
        .collection('login_attempts')
        .doc(email)
        .collection('attempts')
        .add({'timestamp': now});
  }
}