import 'package:flutter/material.dart';

import '../../../utility/constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Welcome to SimpliBudget",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding * 2),
        const Row(
          children: [
            Spacer(),
            Expanded(
                flex: 5,
                child: Image(
                  image: AssetImage("assets/images/welcome_screen_image.png"),
                )),
            Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
