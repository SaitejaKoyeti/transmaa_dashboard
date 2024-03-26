import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Send a verification email
  static Future<void> sendEmailVerification({
    required String email,
    required Function onError,
    required Function onSuccess,
  }) async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        onSuccess();
      } else {
        onError('User not found or email is already verified.');
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify the email with a confirmation code
  static Future<String> verifyEmail({
    required String email ,
    required String confirmationCode,
  }) async {
    try {
      await _firebaseAuth.applyActionCode(confirmationCode);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // Check whether the user is logged in or not
  static Future<bool> isLoggedIn() async {
    User? user = _firebaseAuth.currentUser;
    return user != null;
  }
}