import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserModel?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      // Create user in Firebase Auth
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) return null;

      // Update display name
      await user.updateDisplayName(name);

      // Create user model
      final UserModel userModel = UserModel(
        uid: user.uid,
        name: name,
        email: email,
        role: role,
        createdAt: DateTime.now(),
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) return null;

      // Get user data from Firestore
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        throw 'User data not found. Please contact support.';
      }

      return UserModel.fromSnapshot(userDoc);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      if (e is String) rethrow;
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Failed to sign out. Please try again.';
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) return null;

      return UserModel.fromSnapshot(userDoc);
    } catch (e) {
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    required String name,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'name': name,
      });

      await currentUser?.updateDisplayName(name);
    } catch (e) {
      throw 'Failed to update profile. Please try again.';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to send password reset email. Please try again.';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication error: ${e.message ?? "Unknown error"}';
    }
  }
}
