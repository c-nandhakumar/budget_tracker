import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/screen_size.dart';

class DateRemainingContainer extends StatefulWidget {
  const DateRemainingContainer({super.key});

  @override
  State<DateRemainingContainer> createState() => _DateRemainingContainerState();
}

class _DateRemainingContainerState extends State<DateRemainingContainer> {
  @override
  Widget build(BuildContext context) {
    //current date
    DateTime datenow = DateTime.now();
    String formattedDate = DateFormat('MMM dd').format(datenow);
//remaining days
    DateTime firstDayOfNextMonth = DateTime(datenow.year, datenow.month + 1, 1);
    Duration remainingDuration = firstDayOfNextMonth.difference(datenow);
    int remainingDays = remainingDuration.inDays;

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
              formattedDate,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                remainingDays.toString(),
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
              ),
            ),
            Text(
              "Days remaining",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
