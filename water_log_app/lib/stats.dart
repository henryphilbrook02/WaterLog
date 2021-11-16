import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  var sum = 0.0;
  var day = "";
  var myDay;
  var mySums = [];
  var myDays = [];

  Future<wData> postRequest() async {
    print("In METHOD");

    double average = 0;
    final response = await http.get(
        Uri.parse('http://10.11.25.60:443/api/seven_day_readout/Maaloufer'));

    if (response.statusCode == 200) {
      for (var i = 0; i < 7; i++) {
        var mainUser = wData.fromJson(jsonDecode(response.body)[i]);
        sum = mainUser.wSum.toDouble();
        day = mainUser.wDay.toString();
        DateTime dt = DateTime.parse(day);
        myDay = DateFormat('EEEE').format(dt);

        mySums.add(sum);
        myDays.add(myDay);

        print("Average: " + average.toString());
        print("Sum: " + sum.toString());
        print("I" + i.toString() + ": " + myDays[i].toString());
      }

      return wData.fromJson(jsonDecode(response.body)[0]);

      print("The sums are this: " + mySums.length.toString());
      for (var i = 0; i < mySums.length; i++) {
        print(mySums[i]);
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = getChartData();

    Future.delayed(Duration.zero, () async {
      await postRequest();

      setState(() {
        mySums = mySums;
      });
      setState(() {
        myDays = myDays;
      });

      _tooltipBehavior = TooltipBehavior(enable: true);
      _chartData = getChartData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _chartData = getChartData();
    // _tooltipBehavior = TooltipBehavior(enable: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Weekly Stats for User"),
        elevation: 1,
      ),
      body: SfCartesianChart(
          title: ChartTitle(text: 'Weekly Water Usage'),
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries>[
            BarSeries<GDPData, String>(
                isTrackVisible: false,
                opacity: 0.5,
                color: const Color.fromRGBO(51, 153, 255, 255),
                name: "Title",
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
    );
  }

  List<GDPData> getChartData() {
    final List<GDPData> chartData = [];
    for (int i = 0; i < mySums.length; i++) {
      // if ((mySums[i] > fullAverage)) {
      //   gColor = Colors.red;
      // } else {
      //   gColor = Colors.green;
      // }
      chartData.add(GDPData(myDays[i], mySums[i], Colors.red));
    }
    return chartData;
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.segmentColor);
  final String continent;
  final double gdp;
  final Color segmentColor;
}

class wData {
  int wSum;
  String wDay;

  wData({required this.wSum, required this.wDay});

  factory wData.fromJson(Map<String, dynamic> json) {
    return wData(wSum: json['sum(amount)'], wDay: json['day']);
  }
}
