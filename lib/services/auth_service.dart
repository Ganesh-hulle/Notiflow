import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize Google Sign-In (mostly for web/maintenance of scopes if needed)
  static Future<void> initializeGoogle() async {
    // Basic initialization if needed, though usually handled by the plugin automatically
  }

  /// Sign in with Google and Firebase.
  /// Returns a tuple of (User?, isNewUser).
  static Future<(User?, bool)> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        final userCred = await _auth.signInWithPopup(provider);
        final isNew = userCred.additionalUserInfo?.isNewUser ?? false;
        return (userCred.user, isNew);
      } else {
        // Use the Web client ID from google-services.json (client_type: 3)
        // This is required for Android to show the proper account picker
        final GoogleSignIn googleSignIn = GoogleSignIn(
          serverClientId: '866006552998-rk89tp7b3of1eemon3j315egod31rucl.apps.googleusercontent.com',
        );
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          // User canceled the sign-in flow
          return (null, false);
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        
        final isNew = userCredential.additionalUserInfo?.isNewUser ?? false;

        return (userCredential.user, isNew);
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await GoogleSignIn().signOut();
      }
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Auth state stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
}
