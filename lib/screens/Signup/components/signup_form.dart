// ignore_for_file: use_build_context_synchronously

import 'package:budget_app/services/firebase_auth_methods.dart';
import 'package:budget_app/utility/showsnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final currentNode = FocusNode();
  final nextNode = FocusNode();
  bool isNotVisible = true;
  bool isConfirmPasswordVisible = true;
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> signUpWithEmail() async {
    if (displayNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      if ((passwordController.text.isNotEmpty &&
              confirmPasswordController.text.isNotEmpty) &&
          (passwordController.text.isNotEmpty ==
              confirmPasswordController.text.isNotEmpty)) {
        setState(() {
          isLoading = true;
        });
        final UserCredential? value = await context
            .read<FirebaseAuthMethods>()
            .signUpWithEmail(
                email: emailController.text,
                password: passwordController.text,
                context: context);

        if (value != null) {
          final provider = Provider.of<BackEndProvider>(context, listen: false);
          try {
            await FirebaseAuth.instance.currentUser!
                .updateDisplayName(displayNameController.text);

            ///Creates user in the backend
            await postUser();

            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setBool("newUserHistory", true);
            prefs.setBool("newUserHome", true);
            prefs.setBool("newUser", true);

            ///sets the substatus as free
            prefs.setString("substatus", "free");

            await createExpenseMethod(
                provider: provider,
                emname: "CASH",
                emdetail: "CASH",
                emisdefault: true,
                emshortname: "CASH");

            // final provider = Provider.of<BackEndProvider>(context, listen: false);
            // await getExpenseMethods(provider);
          } on FirebaseAuthException catch (e) {
            showSnackBar(context, e.message.toString());
          }

          provider.setNewUser(true);
          setState(() {
            isLoading = false;
          });

          Navigator.of(context).pop();
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
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        showSnackBar(context, "Please enter the same password");
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              controller: displayNameController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Your name",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.mail),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.next,
              focusNode: currentNode,
              onFieldSubmitted: (term) {
                currentNode.unfocus();
                FocusScope.of(context).requestFocus(nextNode);
              },
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
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              focusNode: nextNode,
              controller: confirmPasswordController,
              textInputAction: TextInputAction.done,
              obscureText: isConfirmPasswordVisible,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                  hintText: "Confirm password",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock),
                  ),
                  suffixIcon: InkWell(
                    onTap: () => setState(() {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: isConfirmPasswordVisible
                          ? const Icon(Icons.remove_red_eye_outlined)
                          : const Icon(
                              Icons.remove_red_eye,
                              color: Colors.blue,
                            ),
                    ),
                  )),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          // ignore: sized_box_for_whitespace
          Container(
            width: SizeConfig.width! * 90,
            child: ElevatedButton(
              onPressed: () async {
                await signUpWithEmail();
              },
              child: isLoading
                  ? const SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ))
                  : Text("Sign Up".toUpperCase()),
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
                    return const LoginScreen();
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
