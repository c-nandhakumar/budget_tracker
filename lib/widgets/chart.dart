import 'package:budget_app/common/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../provider/app_provider.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  late List<_ChartData> data;
  late List<_ChartData> totalData;
  late TooltipBehavior _tooltip;
  late Future<String> expenseSummary;
  @override
  void initState() {
    _tooltip = TooltipBehavior(
      enable: true,
    );
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    expenseSummary = getSummary(provider);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    if (provider.budget != null && provider.budget!.budgets.isNotEmpty) {
      var maximum = 0;
      int index = -1;
      // ignore: unused_local_variable
      int selectedIndex = 0;
      data = [
        ...provider.budget!.budgets.map((e) {
          if (e.budgetamount > maximum) {
            maximum = e.budgetamount;
          }
          index++;
          return _ChartData(
              e.budgetname, e.budgetamount, getColorByIndex(index));
        })
      ];

      data = data.sublist(0, data.length % 13);

      return FutureBuilder(
          future: expenseSummary,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final provider = Provider.of<BackEndProvider>(context);
              Map<String, dynamic> expenseSummary = provider.expenseSummary;

              ///Total Amount Spent List [Update]
              List<TotalSpentData> totalSpentDataList = [];

              expenseSummary.forEach((key, value) {
                totalSpentDataList.add(
                    TotalSpentData(key, value["ExpenseBudgetTotal"] as int));
              });

              SfCartesianChart chart = SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    minorGridLines: const MinorGridLines(width: 0)),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: maximum + 100,
                  interval: maximum / 5,
                  borderColor: const Color.fromARGB(0, 255, 255, 255),
                  majorGridLines: const MajorGridLines(width: 0),
                  minorGridLines: const MinorGridLines(width: 0),
                  //edgeLabelPlacement: EdgeLabelPlacement.shift
                ),
                tooltipBehavior: _tooltip,
                onAxisLabelTapped: (axisLabelTapArgs) {
                  print(axisLabelTapArgs.text);

                  provider.setSelectedInsights(axisLabelTapArgs.text);
                },
                // series: <ChartSeries<_ChartData, String>>[
                series: [
                  ColumnSeries<_ChartData, String>(
                      dataSource: data,
                      borderRadius: BorderRadius.circular(3.5),
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      //pointColorMapper: (_ChartData data, _) => data.color,
                      name: 'Expense',
                      color: Theme.of(context).colorScheme.primary),
                  ColumnSeries<TotalSpentData, String>(
                      dataSource: totalSpentDataList,
                      borderRadius: BorderRadius.circular(3.5),
                      xValueMapper: (TotalSpentData data, _) => data.x,
                      yValueMapper: (TotalSpentData data, _) => data.y,
                      //pointColorMapper: (_ChartData data, _) => data.color,
                      name: 'Total Spent',
                      color: Theme.of(context).colorScheme.inversePrimary),
                ],
              );
              return Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                      width: (data.length % 13) * 100 > SizeConfig.width! * 100
                          ? (data.length % 13) * 100
                          : SizeConfig.width! * 100,
                      height: SizeConfig.height! * 27.5,
                      child: chart),
                ),
              );
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
          });
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 48,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(color: Colors.grey, offset: Offset(-4, 4))
                  ],
                  color: Colors.white,
                  border: Border.all(width: 1),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: const Text("Add budget to display the chart"),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.color);

  final String x;
  final int y;
  final Color color;
}

Color getColorByIndex(int index) {
  int hue = 360 ~/ (index + 1);
  return HSVColor.fromAHSV(1.0, hue.toDouble(), 1.0, 1.0).toColor();
}

class TotalSpentData {
  TotalSpentData(this.x, this.y);

  final String x;
  final int y;
}
