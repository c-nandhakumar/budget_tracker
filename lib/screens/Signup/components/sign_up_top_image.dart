// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../utility/constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign Up".toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 2,
              child: Image(
                  image: AssetImage("assets/images/signup_compressed.jpg")),
            ),
            Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
