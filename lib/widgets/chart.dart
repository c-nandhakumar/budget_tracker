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
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    // data = [
    //   _ChartData('Food', 160),
    //   _ChartData('Gas', 150),
    //   _ChartData('Rent', 120),
    //   _ChartData('Travel', 100),
    //   _ChartData('Food', 130)
    // ];
    _tooltip = TooltipBehavior(
      enable: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    if (provider.budget != null && provider.budget!.budgets.isNotEmpty) {
      var maximum = 0;
      int index = -1;
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

      SfCartesianChart chart = SfCartesianChart(
        // zoomPanBehavior: ZoomPanBehavior(
        //   enablePanning: true, // Enable panning
        //   enablePinching: true, // Enable zooming
        //   enableDoubleTapZooming: true,
        //   // Enable double-tap zooming
        // ),

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
        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
              dataSource: data,
              borderRadius: BorderRadius.circular(3.5),
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              //pointColorMapper: (_ChartData data, _) => data.color,
              name: 'Expense',
              color: Theme.of(context).colorScheme.primary),
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
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: Text("Add a Budget to display the chart")),
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
