// ignore: unused_import
import 'package:budget_app/widgets/expense_methods_chart.dart';
import 'package:budget_app/widgets/recurring_expense_chart.dart';
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
  late Future<String> expenseSummary;
  late Future<String> expenses;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    expenseSummary = getSummary(provider);
    expenses = getExpenses(provider);
  }

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
        FutureBuilder(
            future: expenseSummary,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const ChartWidget();
              } else if (snapshot.hasError) {
                print(snapshot.data);
                return SizedBox(
                  height: SizeConfig.height! * 27.5,
                  child: const Center(
                    child: Text("Oops , Something went wrong"),
                  ),
                );
              } else {
                return SizedBox(
                  height: SizeConfig.height! * 27.5,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
        (provider.budget != null && provider.budget!.budgets.isNotEmpty)
            ? const Divider(
                endIndent: 12,
                indent: 12,
              )
            : Container(),
        (provider.budget != null && provider.budget!.budgets.isNotEmpty)
            ? FutureBuilder(
                future: expenses,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const PieChartWidget();
                  } else if (snapshot.hasError) {
                    print(snapshot.data);
                    return SizedBox(
                      height: SizeConfig.height! * 27.5,
                      child: const Center(
                        child: Text("Oops , Something went wrong"),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: SizeConfig.height! * 27.5,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                })
            : Container(),
        (provider.budget != null && provider.budget!.budgets.isNotEmpty)
            ? const Divider(
                endIndent: 12,
                indent: 12,
              )
            : Container(),
        (provider.budget != null && provider.budget!.budgets.isNotEmpty)
            ? FutureBuilder(
                future: expenseSummary,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const ExpenseMethodsChart();
                  } else if (snapshot.hasError) {
                    print(snapshot.data);
                    return SizedBox(
                      height: SizeConfig.height! * 27.5,
                      child: const Center(
                        child: Text("Oops , Something went wrong"),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: SizeConfig.height! * 27.5,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                })
            : Container(),
        (provider.budget != null && provider.budget!.budgets.isNotEmpty)
            ? const Divider(
                endIndent: 12,
                indent: 12,
              )
            : Container(),
        (provider.budget != null && provider.budget!.budgets.isNotEmpty)
            ? FutureBuilder(
                future: expenses,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const RecurringExpenseChart();
                  } else if (snapshot.hasError) {
                    print(snapshot.data);
                    return SizedBox(
                      height: SizeConfig.height! * 27.5,
                      child: const Center(
                        child: Text("Oops , Something went wrong"),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: SizeConfig.height! * 27.5,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                })
            : Container(),
      ]),
    );
  }
}
