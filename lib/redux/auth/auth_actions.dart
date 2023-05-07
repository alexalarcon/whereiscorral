import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:whereiscorral/pages/login/login.dart';

import '../../services/authentication.dart';
import '../App.state.dart';
import 'auth.model.dart';
import 'auth_state.dart';

@immutable
class AuthStateAction {
  final AuthState authState;

  const AuthStateAction(this.authState);
  @override
  String toString() {
    return 'AuthStateAction { }';
  }
}

Future<void> currentUser(Store<AppState> store) async {
  store.dispatch(AuthStateAction(
      AuthState(false, "", false, AuthModel(), null, {}, false)));
  try {
    final User? user = await Authentication.currentUser();
    var claims = await Authentication.customClaims();

    if (user != null) {
      store.dispatch(AuthStateAction(
          AuthState(false, "", false, AuthModel(), user, claims, false)));
    }
  } catch (error) {
    store.dispatch(AuthStateAction(AuthState(
        true, error.toString(), false, AuthModel(), null, {}, false)));
  }
}

Future<void> authEmailPasswordAction(Store<AppState> store, String email,
    String pass, BuildContext context) async {
  try {
    final User? user = await Authentication.signInEmailAndPassWord(email, pass);

    var claims = await Authentication.customClaims();

    if (user != null) {
      store.dispatch(AuthStateAction(
          AuthState(true, "", false, AuthModel(), user, claims, false)));

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          //TODO
          MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      store.dispatch(AuthStateAction(AuthState(
          true,
          "Usuario o contraseña incorrectos",
          false,
          AuthModel(),
          null,
          {},
          false)));
    }
  } catch (error) {
    store.dispatch(AuthStateAction(AuthState(
        true, "error.toString()", false, AuthModel(), null, {}, false)));
  }
}

Future<void> signOut(Store<AppState> store) async {
  store.dispatch(AuthStateAction(
      AuthState(false, "", false, AuthModel(), null, {}, false)));
  try {
    Authentication.signOut();
    store.dispatch(AuthStateAction(
        AuthState(true, "", false, AuthModel(), null, {}, false)));
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => const RutesPage()));
  } catch (error) {
    store.dispatch(AuthStateAction(AuthState(
        true, error.toString(), false, AuthModel(), null, {}, false)));
  }
}

Future<void> resetPassword(
    Store<AppState> store, String email, BuildContext context) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    backgroundColor: const Color(0xFF64F0A4),
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.all(20),
    content: const Text(
        'Te hemos enviado un correo electrónico con instrucciones para restablecer tu contraseña.',
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 15, color: Colors.black87)),
  ));
  Authentication.resetEmailAndPassWord(email);
}
