import 'package:budget_app/screens/bottomnavigation.dart';
import 'package:budget_app/screens/home_screen.dart';
import 'package:budget_app/services/firebase_auth_methods.dart';
import 'package:budget_app/utility/showsnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/screen_size.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../provider/app_provider.dart';
import '../../../utility/constants.dart';

import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> signUpWithEmail() async {
    await context
        .read<FirebaseAuthMethods>()
        .signUpWithEmail(
            email: emailController.text,
            password: passwordController.text,
            context: context)
        .then((value) {
      print("Sign up ====> ${value!.user!.emailVerified}");
    });

    final provider = Provider.of<BackEndProvider>(context, listen: false);
    await getBudgetData(provider);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BottomNavBar(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          Container(
            width: SizeConfig.width! * 90,
            child: ElevatedButton(
              onPressed: signUpWithEmail,
              child: Text("Sign Up".toUpperCase()),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
