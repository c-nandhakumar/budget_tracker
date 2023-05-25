import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../common/screen_size.dart';
import '../provider/app_provider.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  late Future<String> expenses;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    expenses = getExpenses(provider);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: expenses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final provider = Provider.of<BackEndProvider>(context);
            // getTotal(provider, provider.selectedBudget!, provider.selectedBudgetIndex);
            final recentMap = {};

            if (provider.expenses != null) {
              provider.expenses!.forEach((e) {
                print("Selected budget ======> ${provider.selectedBudget}");
                if (e.budgetname == provider.selectedInsights) {
                  recentMap.putIfAbsent(e.categoryname, () => e.expensecost);
                  recentMap.update(
                      e.categoryname, (value) => value += e.expensecost);
                }
              });
              var total = 0;

              recentMap.forEach((key, value) {
                total += value as int;
              });
              List<Data> data = [];
              int index = 0;
              recentMap.forEach(
                (key, value) {
                  data.add(Data(key, value, getShadeOfPurple(index),
                      ((value / total) * 100)));
                  index++;
                },
              );

              return Column(children: [
                Container(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Text(
                    '${provider.selectedInsights ?? provider.selectedBudget}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                recentMap.isNotEmpty
                    ? Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SfCircularChart(
                              //legend: Legend(isVisible: true),
                              series: <CircularSeries>[
                                PieSeries<Data, String>(
                                  dataSource: data,
                                  xValueMapper: (Data data, _) => data.category,
                                  yValueMapper: (Data data, _) => data.value,
                                  pointColorMapper: (Data data, _) =>
                                      data.color,
                                  dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                      labelAlignment:
                                          ChartDataLabelAlignment.outer,
                                      labelPosition:
                                          ChartDataLabelPosition.outside,
                                      textStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                  dataLabelMapper: (Data data, _) =>
                                      '${data.category}',
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SfCircularChart(
                              //legend: Legend(isVisible: true),
                              series: <CircularSeries>[
                                PieSeries<Data, String>(
                                  dataSource: data,
                                  xValueMapper: (Data data, _) => data.category,
                                  yValueMapper: (Data data, _) => data.value,
                                  pointColorMapper: (Data data, _) =>
                                      data.color,
                                  dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                      labelAlignment:
                                          ChartDataLabelAlignment.outer,
                                      labelPosition:
                                          ChartDataLabelPosition.inside,
                                      textStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                  dataLabelMapper: (Data data, _) =>
                                      '${data.percent.toStringAsFixed(2)}%',
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Container(
                            height: SizeConfig.height! * 20,
                            width: SizeConfig.width! * 70,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: Theme.of(context).colorScheme.secondary),
                            padding: const EdgeInsets.all(30),
                            child: const Center(
                              child: Text(
                                "There is no enough content to show charts",
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
              ]);
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                    child: Text(
                        "No Transactions Yet. To add transaction, Flip the category card and add the expenses")),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

Color getColorByIndex(int index) {
  int hue = 360 ~/ (index + 11);
  return HSVColor.fromAHSV(1.0, hue.toDouble(), 1.0, 1.0).toColor();
}

Color getShadeOfPurple(int index) {
  const double opacity = 1.0; // Set the desired opacity value
  const int baseRed = 128; // Set the base red value
  const int baseGreen = 3; // Set the base green value
  const int baseBlue = 128; // Set the base blue value
  const int step = 20; // Set the step size for each shade

  int red = (baseRed + (index * step)).clamp(0, 255).toInt();
  int green = (baseGreen + (index * step)).clamp(0, 255).toInt();
  int blue = (baseBlue + (index * step)).clamp(0, 255).toInt();

  return Color.fromRGBO(red, green, blue, opacity);
}

class Data {
  final String category;
  final int value;
  final Color color;
  final double percent;

  Data(this.category, this.value, this.color, this.percent);
}
