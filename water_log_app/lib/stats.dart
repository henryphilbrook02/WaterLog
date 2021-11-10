import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

var sum;
var day;
var myDay;

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
    postRequest();
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
    // debugPrint("Sum: " + sum);
    // debugPrint("Day: " + day);
    // 7
    // GET Query based on the user ID for that last 7* days
    // then set that as a GPDData opject, and add it to chartData list.

    final List<GDPData> chartData = [
      GDPData("Sunday", 16, Colors.blue),
      GDPData('Saturday', 46, Colors.red),
      GDPData('Friday', 15, Colors.blue),
      GDPData(myDay, sum, Colors.red),
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

Future<wData> postRequest() async {
  final response = await http
      .get(Uri.parse('http://10.11.25.60:443/api/seven_day_readout/Maaloufer'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    // for (var i = 0; i < 2; i++) {
    //   x = User.fromJson(jsonDecode(response.body)[i]);
    //   debugPrint(x.userName.toString());
    // }
    var mainUser = wData.fromJson(jsonDecode(response.body)[0]);
    sum = mainUser.wSum.toDouble();
    day = mainUser.wDay.toString();

    DateTime dt = DateTime.parse(day);

    myDay = DateFormat('EEEE').format(dt);

    return wData.fromJson(jsonDecode(response.body)[0]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class wData {
  int wSum;
  String wDay;

  wData({required this.wSum, required this.wDay});

  factory wData.fromJson(Map<String, dynamic> json) {
    return wData(wSum: json['sum(amount)'], wDay: json['day']);
  }
}
