import 'package:budget_app/widgets/recents_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/screen_size.dart';
import '../provider/app_provider.dart';
import '../widgets/chart.dart';
import '../widgets/pie_chart_widget.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  // final recent_list = [
  //   {"name": "Food", "cost": "\$160"},
  //   {"name": "Gas", "cost": "\$160"},
  //   {"name": "Rent", "cost": "\$160"}
  // ];
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    // final recent_list = [
    //   ...provider.budget!.budgets.map((e) =>
    //       {"name": e.budgetname.toString(), "cost": e.budgetamount.toString()})
    // ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            provider.setBottomNavIndex(0);
          },
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
      body: ListView(children: [
        ChartWidget(),
        (provider.budget != null && provider.budget!.budgets.isNotEmpty)
            ? PieChartWidget()
            : Container(),
      ]),
    );
  }
}


   // Padding(
            //   padding: const EdgeInsets.only(top: 16.0, left: 24.0, bottom: 9),
            //   child: Text(
            //     "Recent",
            //     style: Theme.of(context).textTheme.titleLarge!.copyWith(
            //         color: Theme.of(context).colorScheme.tertiary,
            //         fontWeight: FontWeight.bold),
            //   ),
            // ),
            // ...recent_list.map((e) => RecentContainer(
            //       name: e['name'],
            //       cost: e['cost'],
            //     ))
