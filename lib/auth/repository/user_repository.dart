import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Repository for user profile operations with Firestore.
class UserRepository {
  final FirebaseFirestore _firestore;

  /// Collection name for users
  static const String _usersCollection = 'users';

  UserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get user profile from Firestore by Firebase Auth UID.
  /// Returns null if user does not exist.
  Future<AppUser?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return AppUser.fromJson(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  /// Save user profile to Firestore.
  /// Uses the AppUser.id as the document ID.
  Future<void> saveUser(AppUser user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }

  /// Check if a user exists in Firestore.
  Future<bool> userExists(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      return doc.exists;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }
}
