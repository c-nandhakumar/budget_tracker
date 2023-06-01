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
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Spacer(),
            const Expanded(
              flex: 6,
              child: Image(
                  image: AssetImage("assets/images/signup_compressed.jpg")),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
