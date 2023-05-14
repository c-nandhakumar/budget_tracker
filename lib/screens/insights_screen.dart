import 'package:budget_app/widgets/recents_container.dart';
import 'package:flutter/material.dart';

import '../common/screen_size.dart';
import '../widgets/chart.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final recent_list = [
    {"name": "Food", "cost": "\$160"},
    {"name": "Gas", "cost": "\$160"},
    {"name": "Rent", "cost": "\$160"}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {},
          ),
          toolbarHeight: SizeConfig.height! * 10,
          centerTitle: true,
          title: Text(
            "Insights",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: ChartWidget(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 24.0, bottom: 9),
              child: Text(
                "Recent",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ...recent_list.map((e) => RecentContainer(
                  name: e['name'],
                  cost: e['cost'],
                ))
          ],
        ));
  }
}
