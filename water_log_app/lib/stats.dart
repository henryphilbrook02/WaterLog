//
// Waterlog Capping Group
// Capping class Fall '21
// stats.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:water_log_app/models/userModel.dart' as userModel;
import 'package:water_log_app/custom_theme.dart';

var average = 0.0;
final now = new DateTime.now();
String formatter = DateFormat('yMd').format(now); // 28/03/2020
// Global Class Variables initalized

class stats extends StatelessWidget {
  userModel.User client;
  stats({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme_class.light_theme,
      home: MyHomePage(client: client),
    );
  }
}

class MyHomePage extends StatefulWidget {
  userModel.User client;

  MyHomePage({
    Key? key,
    required this.client,
  }) : super(key: key);

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
  // variables and lists declared to build chart from API data
  var testAverage = 0;
  Future<wData> postRequest() async {
    // post method that gets the seven_day_readout from the API call
    final response = await http.get(Uri.parse(
        'http://10.11.25.60:443/api/seven_day_readout/' +
            widget.client.userName));
    average = 0;
    if (response.statusCode == 200) {
      for (var i = 0; i < 7; i++) {
        // loops through for the most recent week
        try {
          var mainUser = wData.fromJson(jsonDecode(response.body)[i]);
          sum = mainUser.wSum.toDouble();
          day = mainUser.wDay.toString();
          DateTime dt = DateTime.parse(day);
          myDay = DateFormat('EEEE').format(dt);
          average = average + sum;
          print("Average: " + average.roundToDouble().toString());
          mySums.add(sum);
          myDays.add(myDay);
          testAverage++;
        } on Exception catch (exception) {
          print("Error");
        } catch (error) {
          print("Error");
        }
      }

      return wData.fromJson(jsonDecode(response.body)[0]);
    } else {
      throw Exception('Failed to load user');
    }
    // Error handling properly
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
      // Set states for the days and sums

      _tooltipBehavior = TooltipBehavior(enable: true);
      _chartData = getChartData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build the widget for the charts to be filled form the API data
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
                name: "Average: " +
                    (average / mySums.length).roundToDouble().toString(),
                dataSource: _chartData,
                pointColorMapper: (GDPData sales, _) => sales.segmentColor,
                xValueMapper: (GDPData gdp, _) => gdp.usageDay,
                yValueMapper: (GDPData gdp, _) => gdp.usageWater,
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
              title: AxisTitle(text: 'Gallons Per Day - ' + formatter))),
    );
  }

  List<GDPData> getChartData() {
    final List<GDPData> chartData = [];
    // Fills the char data list after parseing info from the API
    try {
      for (int i = 0; i < mySums.length; i++) {
        var fullAverage = average / mySums.length;
        var lowerAverage = fullAverage - 10;
        var highAverage = fullAverage + 10;
        // Split the averages to color the bars
        print("Full: " + fullAverage.toString());
        var gColor;
        if ((mySums[i] > highAverage)) {
          gColor = Colors.red;
        } else if (mySums[i] < lowerAverage) {
          gColor = Colors.green;
        } else {
          gColor = Colors.blue;
        }
        chartData.add(GDPData(myDays[i], mySums[i], gColor));
      }
    } on Exception catch (exception) {
      print("Exception Handled"); // only executed if error is of type Exception
    } catch (error) {
      print("Error Caught"); // only executed if error is of type Exception
      // executed for errors of all types other than Exception
    }
    return chartData;
  }
}

class GDPData {
  // Class for the data
  GDPData(this.usageDay, this.usageWater, this.segmentColor);
  final String usageDay;
  final double usageWater;
  final Color segmentColor;
}

class wData {
  // parsing data class
  int wSum;
  String wDay;
  wData({required this.wSum, required this.wDay});
  factory wData.fromJson(Map<String, dynamic> json) {
    return wData(wSum: json['sum(amount)'], wDay: json['day']);
  }
}
