import 'package:flutter/material.dart';

import '../common/screen_size.dart';

class DateRemainingContainer extends StatefulWidget {
  const DateRemainingContainer({super.key});

  @override
  State<DateRemainingContainer> createState() => _DateRemainingContainerState();
}

class _DateRemainingContainerState extends State<DateRemainingContainer> {
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
              "May 02",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "29",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
              ),
            ),
            Text(
              "Days remaining",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
