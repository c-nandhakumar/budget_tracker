import 'package:flutter/material.dart';

import '../../components/background.dart';
import 'components/login_form.dart';
import 'components/login_screen_top_image.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return // Background(
        // child: SingleChildScrollView(
        //   child: Responsive(
        //child:
        // ignore: prefer_const_constructors
        Scaffold(body: Background(child: const MobileLoginScreen()));
    //     desktop: Row(
    //       children: [
    //         const Expanded(
    //           child: LoginScreenTopImage(),
    //         ),
    //         Expanded(
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: const [
    //               SizedBox(
    //                 width: 450,
    //                 child: LoginForm(),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // ),
    //);
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           LoginScreenTopImage(),
          Row(
            children:  [
              Spacer(),
              Expanded(
                flex: 10,
                child: LoginForm(),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
