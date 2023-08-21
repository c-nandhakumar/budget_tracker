// ignore_for_file: use_build_context_synchronously

import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/screens/bottomnavigation.dart';
import 'package:budget_app/services/firebase_auth_methods.dart';
import 'package:budget_app/utility/showsnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../provider/app_provider.dart';
import '../../../utility/constants.dart';

import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isNotVisible = true;
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  ///Make the user to Login if the credentials are true,
  ///if not then it displays a snackbar
  Future<void> loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = !isLoading;
      });
      final UserCredential? value = await context
          .read<FirebaseAuthMethods>()
          .loginWithEmail(
              email: emailController.text,
              password: passwordController.text,
              context: context);

      if (value != null) {
        print("Value ====> ${value.user!.uid}");
        print(value.additionalUserInfo?.isNewUser);
        final provider = Provider.of<BackEndProvider>(context, listen: false);
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        ///If the user uninstalls and reinstalls the app again
        ///this will not show the tutorial screen
        if (prefs.containsKey("newUserHistory") == false) {
          prefs.setBool("newUserHistory", false);
        }
        if (prefs.containsKey("newUserHome") == false) {
          prefs.setBool("newUserHome", false);
        }

        if (prefs.containsKey("newUser") == false) {
          prefs.setBool("newUser", false);
        }

        provider.setBottomNavIndex(0);
        await getExpenseMethods(provider);
        setState(() {
          isLoading = !isLoading;
        });

        provider.setNewUser(false);

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShowCaseWidget(
            builder: Builder(builder: (context) {
              return const BottomNavBar();
            }),
          ),
        ));
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text(
                "A Verification Link has been sent to your entered email. Please Verify it to Login"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"))
            ],
          ),
        );
        setState(() {
          isLoading = !isLoading;
        });
      }
    } else {
      showSnackBar(context, "Please enter the necessary details to continue");
    }
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
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: isNotVisible,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
                suffixIcon: InkWell(
                  onTap: () => setState(() {
                    isNotVisible = !isNotVisible;
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: isNotVisible
                        ? const Icon(Icons.remove_red_eye_outlined)
                        : const Icon(
                            Icons.remove_red_eye,
                            color: Colors.blue,
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            // ignore: sized_box_for_whitespace
            child: Container(
              width: SizeConfig.width! * 90,
              child: ElevatedButton(
                onPressed: loginUser,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0),
                child: isLoading
                    ? const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        "Login".toUpperCase(),
                      ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
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
