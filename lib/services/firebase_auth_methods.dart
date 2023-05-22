import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utility/showsnackbar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  User get _user => _auth.currentUser!;
//state persistence
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  //email signup
  Future<UserCredential?> signUpWithEmail(
      {required email,
      required password,
      required BuildContext context}) async {
    try {
      final value = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // ignore: use_build_context_synchronously
      await sendEmailVerification(context);
      return value;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return null;
  }

  //email login
  Future<UserCredential?> loginWithEmail(
      {required email,
      required password,
      required BuildContext context}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        // ignore: use_build_context_synchronously
        await sendEmailVerification(context);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return null;
  }

  //email verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      // ignore: use_build_context_synchronously
      showSnackBar(context, "Email Verification sent!");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
