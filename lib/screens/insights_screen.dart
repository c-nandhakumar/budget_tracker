// ignore: unused_import
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
 
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
   
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
        const ChartWidget(),
        (provider.budget != null && provider.budget!.budgets.isNotEmpty)
            ? const PieChartWidget()
            : Container(),
      ]),
    );
  }
}



