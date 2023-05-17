import 'package:budget_app/common/screen_size.dart';
import 'package:flutter/material.dart';

import '../../../utility/constants.dart';
import '../../Login/login_screen.dart';
import '../../Signup/signup_screen.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: Container(
            width: SizeConfig.width! * 90,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
              child: Text(
                "Login".toUpperCase(),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: SizeConfig.width! * 90,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryLightColor, elevation: 0),
            child: Text(
              "Sign Up".toUpperCase(),
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
