import 'package:flutter/material.dart';

import '../../../utility/constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: defaultPadding * 2),
        Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Spacer(),
            Expanded(
              flex: 5,
              child: Image(image: AssetImage("assets/images/login.png")),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
