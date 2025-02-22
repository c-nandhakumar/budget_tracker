import 'package:budget_app/common/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../provider/app_provider.dart';

class ExpenseMethodsChart extends StatefulWidget {
  const ExpenseMethodsChart({super.key});

  @override
  State<ExpenseMethodsChart> createState() => _ExpenseMethodsChartState();
}

class _ExpenseMethodsChartState extends State<ExpenseMethodsChart> {
  // late List<_ChartData> data;
  late List<_ChartData> totalData;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(
      enable: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);

    if (provider.budget != null && provider.budget!.budgets.isNotEmpty) {
      // data = data.sublist(0, data.length % 13);

      var maximum = 0;
      final provider = Provider.of<BackEndProvider>(context);
      Map<String, dynamic> expenseSummaryData = provider.expenseSummary;

      ///Total Amount Spent List [Update]
      List<TotalSpentData> totalSpentDataList = [];

      Map<String, int>.from(expenseSummaryData[provider.selectedInsights]
              ["ExpenseEmShortTotal"])
          .forEach((key, value) {
        if (value > maximum) {
          maximum = value;
        }
        totalSpentDataList.add(TotalSpentData(key, value));
      });
      int data = totalSpentDataList.length;
      if (totalSpentDataList.isNotEmpty) {
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
            provider.setSelectedInsights(axisLabelTapArgs.text);
          },
          // series: <ChartSeries<_ChartData, String>>[
          series: [
            ColumnSeries<TotalSpentData, String>(
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(fontSize: 12),
                ),
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 24.0),
                child: const Text(
                  'Expense Methods Chart',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                    width: (data % 13) * 100 > SizeConfig.width! * 100
                        ? (data % 13) * 100
                        : SizeConfig.width! * 100,
                    height: SizeConfig.height! * 27.5,
                    child: chart),
              ),
            ],
          ),
        );
      } else {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 24.0),
              child: const Text(
                'Expense Methods Chart',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                  height: SizeConfig.height! * 20,
                  width: SizeConfig.width! * 70,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Theme.of(context).colorScheme.secondary),
                  padding: const EdgeInsets.all(30),
                  child: const Center(
                    child: Text(
                      "There is no enough data to show expense method chart",
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
          ],
        );
      }
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
