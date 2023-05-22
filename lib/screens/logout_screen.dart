import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/services/firebase_auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
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
