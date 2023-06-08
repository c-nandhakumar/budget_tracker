import 'package:budget_app/screens/bottomnavigation.dart';
import 'package:budget_app/services/firebase_auth_methods.dart';
import 'package:budget_app/utility/showsnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
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
    if ((passwordController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty) &&
        (passwordController.text.isNotEmpty ==
            confirmPasswordController.text.isNotEmpty)) {
      if (displayNameController.text.isNotEmpty) {
        final UserCredential? value = await context
            .read<FirebaseAuthMethods>()
            .signUpWithEmail(
                email: emailController.text,
                password: passwordController.text,
                context: context);

        try {
          await FirebaseAuth.instance.currentUser!
              .updateDisplayName(displayNameController.text);
          await postUser();
          await createExpenseMethod(
              emname: "CASH",
              emdetail: "CASH",
              emisdefault: true,
              emshortname: "CASH");
          // ignore: use_build_context_synchronously
          final provider = Provider.of<BackEndProvider>(context, listen: false);
          await getExpenseMethods(provider);
        } on FirebaseAuthException catch (e) {
          // ignore: use_build_context_synchronously
          showSnackBar(context, e.message.toString());
        }

        // ignore: use_build_context_synchronously
        if (value != null) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ));
        }
      }
    } else {
      showSnackBar(context, "Please enter the same password");
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
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              controller: confirmPasswordController,
              textInputAction: TextInputAction.done,
              obscureText: isNotVisible,
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
                setState(() {
                  isLoading = true;
                });
                await signUpWithEmail();
                setState(() {
                  isLoading = false;
                });
              },
              child: isLoading
                  ? const SizedBox(
                      height: 10, width: 10, child: CircularProgressIndicator())
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
