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
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: -20,
                right: -20,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7C3BB9),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Today",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      formattedDate,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        remainingDays.toString(),
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
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
            ],
          ),
        ));
  }
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 100;

    Path path = Path();
    path
      ..moveTo(size.width / 2, 0)
      ..arcToPoint(Offset(size.width, size.height),
          radius: Radius.circular(radius))
      ..lineTo(0, size.height)
      ..arcToPoint(
        Offset(size.width / 2, 0),
        radius: Radius.circular(radius),
      )
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
