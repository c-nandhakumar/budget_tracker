import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utility/showsnackbar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);
  // ignore: unused_element
  User get _user => _auth.currentUser!;

  ///STATE PERSISTENCE
  ///this is used to persist the AUTH STATE
  ///whether there is a user logged in or logged out
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  ///EMAIL SIGNUP
  ///This function will make a new user with password
  ///and also it triggers the email verification too
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

  ///EMAIL LOGIN
  ///This function is used to Login to the account
  Future<UserCredential?> loginWithEmail(
      {required email,
      required password,
      required BuildContext context}) async {
    try {
      final value = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        // ignore: use_build_context_synchronously
        await sendEmailVerification(context);

        ///-----null-----
        return value;

        ///This line will send verification code to the user
        ///you can make the email verification mandatory by not returing the value
      }

      ///you can add this return value statement in a else block and show a snackbar to notify the user
      ///that they can only login by verifying the email, like this
      /// if(!_auth.currentUser!.emailVerified){
      ///   showSnackBar(context, "Your email is still unverified, Please verify your email to continue")
      ///   await sendEmailVerification(context);
      /// }
      ///
      /// else{
      ///  return value;
      /// }
      return value;

      ///this return value will navigate the user to the next screen
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return null;
  }

  ///EMAIL VERIFICATION
  ///Email verification will be sent to the new users as well as the existing users
  ///who're not verified yet
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      // ignore: use_build_context_synchronously
      // showSnackBar(context, "Email Verification sent!");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  ///SIGN OUT
  ///This function will trigger a signout request to the firebase
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();

      print("SignedOutSuccessfully");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
