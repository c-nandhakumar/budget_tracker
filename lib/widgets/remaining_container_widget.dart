import 'package:flutter/material.dart';

import '../common/screen_size.dart';

class RemainingContainer extends StatefulWidget {
  const RemainingContainer({super.key});

  @override
  State<RemainingContainer> createState() => _RemainingContainerState();
}

class _RemainingContainerState extends State<RemainingContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.width! * 44,
      width: SizeConfig.width! * 44,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "\$100",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            Text(
              "Balance",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Budget \$3000",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
