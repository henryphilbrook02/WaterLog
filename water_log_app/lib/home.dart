import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:water_log_app/custom_theme.dart';

import 'package:water_log_app/models/userModel.dart' as userModel;


class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme_class.light_theme,
      //home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {

  final email;

  userModel.User client;

  homePage({
    Key? key,
    this.email,
    required this.client,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homePage> {
  late List<GDPData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    print(widget.client.getUserName());
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome Back"),
          elevation: 1,
        ),
        body: SfCircularChart(
          title: ChartTitle(text: 'Current Water Usage'),
          legend: Legend(
              isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
          tooltipBehavior: _tooltipBehavior,
          series: <CircularSeries>[
            RadialBarSeries<GDPData, String>(
                dataSource: _chartData,
                xValueMapper: (GDPData data, _) => data.continent,
                yValueMapper: (GDPData data, _) => data.gdp,
                cornerStyle: CornerStyle.bothCurve,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                enableTooltip: true,
                maximumValue: 200)
          ],
        ));
  }

  List<GDPData> getChartData() {
    final List<GDPData> chartData = [
      GDPData('Showers', 160),
      GDPData('Toilet Flushes', 97),
      GDPData('Washing Machine', 190),
    ];
    return chartData;
  }
}

class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final int gdp;
}
