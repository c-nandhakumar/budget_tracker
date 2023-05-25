import 'package:flutter/material.dart';

import '../../../utility/responsive.dart';

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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoginScreenTopImage(),
          Row(
            children: const [
              Spacer(),
              Expanded(
                flex: 8,
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
