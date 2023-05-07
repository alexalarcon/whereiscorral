import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:whereiscorral/pages/login/login.dart';

// https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/
class Authentication {
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }

    return firebaseApp;
  }

  static Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    await googleSignIn.signOut();
  }

  static Future<User?> currentUser() async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    user = auth.currentUser;
    return user;
  }

  static Future<String?> getTokenId() async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    user = auth.currentUser;
    var token = await user?.getIdToken();
    return token;
  }

  static customClaims() async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    user = auth.currentUser;
    IdTokenResult? result = await (user?.getIdTokenResult());
    return result?.claims;
  }

  static Future<User?> signInEmailAndPassWord(String email, password) async {
    User? user;
    await Firebase.initializeApp();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;

      return user;
    } catch (e) {
      return null;
    }
  }

  static Future<void> resetEmailAndPassWord(String email) async {
    await Firebase.initializeApp();
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        signOut();
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }

    return user;
  }
}
