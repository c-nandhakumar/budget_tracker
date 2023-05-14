import 'package:budget_app/common/screen_size.dart';
import 'package:flutter/material.dart';

class HistoryContainer extends StatelessWidget {
  final String? name;
  final String? date;
  final String? cost;
  const HistoryContainer({super.key, this.name, this.date, this.cost});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Theme.of(context).colorScheme.secondary),
      height: SizeConfig.height! * 12,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 24, vertical: SizeConfig.height! * 1.75),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${name}",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${date}",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w400, color: Color(0xff808080)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "${cost}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ]),
    );
  }
}
