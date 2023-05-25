import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/screens/Welcome/welcome_screen.dart';
import 'package:budget_app/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Are you sure want to logout",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "${user?.email != null ? user?.email : "Email"} ${user?.displayName != null ? user?.displayName : "User"}",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              minimumSize: Size.zero,
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12.5),
            ),
            onPressed: () {
              context.read<FirebaseAuthMethods>().signOut(context);
              // context.read<BackEndProvider>().setUserId();
              AppProviders.disposeAllDisposableProviders(context);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => WelcomeScreen(),
              ));
            },
            child: Text(
              "Log out",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      )),
    );
  }
}
