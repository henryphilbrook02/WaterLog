//
// Waterlog Capping Group
// Capping class Fall '21
// Home.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:water_log_app/custom_theme.dart';
import 'package:http/http.dart' as http;
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
  var curGoal = 0.0;
  // Global Varibales
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
  // Chart Data initalized

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This is the widget that contains the circulat chart
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome Back ${widget.client.userName}"),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: getChartData(),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<GDPData>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  throw Exception('Failed to get goal');
                } else if (snapshot.hasData) {
                  _chartData = snapshot.data!;
                  // API call checks and excptions
                  return Column(children: <Widget>[
                    Container(
                        height: 450,
                        child: SfCircularChart(
                            title: ChartTitle(
                                text: 'Current Water Usage',
                                textStyle: TextStyle(fontSize: 20)),
                            legend: Legend(
                                isVisible: true,
                                overflowMode: LegendItemOverflowMode.wrap),
                            tooltipBehavior: _tooltipBehavior,
                            series: <CircularSeries>[
                              RadialBarSeries<GDPData, String>(
                                  dataSource: _chartData,
                                  xValueMapper: (GDPData data, _) =>
                                      data.usageDay,
                                  yValueMapper: (GDPData data, _) =>
                                      data.usageWater,
                                  pointColorMapper: (GDPData data, _) =>
                                      data.color,
                                  cornerStyle: CornerStyle.bothCurve,
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                  enableTooltip: true,
                                  maximumValue: widget.curGoal)
                              // Filling Chart Data
                            ])),
                    Container(
                      child: Text(
                          "${_chartData[0].usageWater} / ${widget.curGoal} for your Daily Goal\n${_chartData[1].usageWater} / ${(widget.curGoal).roundToDouble()} for your Weekly Average",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 3,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent)),
                    )
                  ]);
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ),
        ));
  }

  Future<List<GDPData>> getChartData() async {
    widget.curGoal = await getGoal(widget.client.userName);
    double cur = await getDay(widget.client.userName);
    double week = await getWeek(widget.client.userName);
    // Variables gathered from api call methods

    var color = Colors.blue;
    var lowerAverage = widget.curGoal - 10;
    var highAverage = widget.curGoal + 10;
    if (cur > highAverage) {
      color = Colors.red;
    } else if (cur < lowerAverage) {
      color = Colors.green;
    } else {
      color = Colors.blue;
    }

    final List<GDPData> chartData = [
      GDPData('Usage', cur, color),
      GDPData('Week', week.roundToDouble(), Colors.blue)
      // Add chart Data to the list
    ];

    return chartData;
  }
}

Future<double> getDay(String username) async {
  // API call to our server to get and then parse the data in the json code
  final response = await http
      .get(Uri.parse('http://10.11.25.60:443/api/cur_day_data/' + username));
  if (response.statusCode == 200) {
    if (jsonDecode(response.body)[0]["sum(amount)"] != null) {
      return jsonDecode(response.body)[0]["sum(amount)"].toDouble();
    }
    return 0.0;
  } else {
    throw Exception('Failed to load user');
  }
}

Future<double> getWeek(String username) async {
  // Same As get Day essentially
  final response = await http
      .get(Uri.parse('http://10.11.25.60:443/api/seven_day_data/' + username));
  if (response.statusCode == 200) {
    if (jsonDecode(response.body)[0]["sum(amount)"] != null) {
      return jsonDecode(response.body)[0]["sum(amount)"].toDouble() / 7;
    }
    return 0.0;
  } else {
    throw Exception('Failed to load user');
  }
}

Future<double> getGoal(String username) async {
  // Same thing as up top
  final response = await http
      .get(Uri.parse('http://10.11.25.60:443/api/cur_goals/' + username));
  if (response.statusCode == 200) {
    if (jsonDecode(response.body)[0]['GOAL'] != null) {
      return jsonDecode(response.body)[0]['GOAL'].toDouble();
    }
    return 0.0;
  } else {
    throw Exception('Failed to load goal');
  }
}

class GDPData {
  // Chart Data class
  GDPData(this.usageDay, this.usageWater, this.color);
  final String usageDay;
  final double usageWater;
  final color;
}
