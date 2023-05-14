import 'package:flutter/material.dart';

import '../common/screen_size.dart';

class RecentContainer extends StatefulWidget {
  final String? name;
  final String? cost;
  const RecentContainer({this.name, this.cost, super.key});

  @override
  State<RecentContainer> createState() => _RecentContainerState();
}

class _RecentContainerState extends State<RecentContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Theme.of(context).colorScheme.secondary),
        height: SizeConfig.height! * 12,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Text(
                  "${widget.name}",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "${widget.cost}",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ]),
      ),
    );
  }
}
