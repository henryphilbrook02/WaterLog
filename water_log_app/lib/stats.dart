import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class stats extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<GDPData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SfCartesianChart(
          title: ChartTitle(text: 'Weekly Water Usage'),
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries>[
            BarSeries<GDPData, String>(
                isTrackVisible: false,
                opacity: 0.5,
                color: const Color.fromRGBO(51, 153, 255, 255),
                name: 'Water Usage',
                dataSource: _chartData,
                pointColorMapper: (GDPData sales, _) => sales.segmentColor,
                xValueMapper: (GDPData gdp, _) => gdp.continent,
                yValueMapper: (GDPData gdp, _) => gdp.gdp,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                dataLabelSettings: DataLabelSettings(isVisible: true),
                width: 0.8, // Width of the bars
                spacing: 0.2, // Spacing between the bars
                enableTooltip: true)
          ],
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              //numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)
              title: AxisTitle(text: 'Gallons Per Day - (09/27/2021)'))),
    ));
  }

  List<GDPData> getChartData() {
    // 7
    // GET Query based on the user ID for that last 7* days
    // then set that as a GPDData opject, and add it to chartData list.

    final List<GDPData> chartData = [
      GDPData('Sunday', 16, Colors.blue),
      GDPData('Saturday', 46, Colors.red),
      GDPData('Friday', 15, Colors.blue),
      GDPData('Thursday', 42, Colors.red),
      GDPData('Wednesday', 30, Colors.green),
      GDPData('Tuesday', 25, Colors.green),
      GDPData('Monday', 46, Colors.red),
    ];

    // for (double i = 0; i < 7; i++) {
    //   chartData.add(GDPData("continent", i, Colors.black));
    // }
    return chartData;
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.segmentColor);
  final String continent;
  final double gdp;
  final Color segmentColor;
}
