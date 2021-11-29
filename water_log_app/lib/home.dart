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
    //print(widget.curGoal);
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome Back ${widget.client.userName}"),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child:
            FutureBuilder<http.Response>(
              future: http.get(Uri.parse('http://10.11.25.60:443/api/cur_goals/'+widget.client.userName)),
              builder: (
                  BuildContext context,
                  AsyncSnapshot<http.Response> snapshot,
                  ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    throw Exception('Failed to get goal');
                  }
                  else if (snapshot.hasData) {
                    widget.curGoal = jsonDecode(snapshot.data!.body)[0]['GOAL'].toDouble();
                    return Column(
                        children: <Widget>[
                            Container (
                              height: 450,
                              child: SfCircularChart(
                                  title: ChartTitle(text: 'Current Water Usage',textStyle: TextStyle(fontSize: 20)),
                                  legend: Legend(
                                      isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                                  tooltipBehavior: _tooltipBehavior,
                                  series: <CircularSeries>[
                                    RadialBarSeries<GDPData, String>(
                                        dataSource: _chartData,
                                        xValueMapper: (GDPData data, _) => data.continent,
                                        yValueMapper: (GDPData data, _) => data.gdp,
                                        pointColorMapper: (GDPData data, _) => data.color,
                                        cornerStyle: CornerStyle.bothCurve,
                                        dataLabelSettings: DataLabelSettings(isVisible: true),
                                        enableTooltip: true,
                                        maximumValue: widget.curGoal)
                                  ]
                              )
                          ),
                          Container(
                            child: Text(
                              "You are at: ${widget.client.currentUsage} out of ${widget.curGoal}",
                              textAlign: TextAlign.center,
                                style: TextStyle(height: 3, fontSize: 20, color: Colors.blueAccent)
                            ),
                          )
                        ]
                    );
                  }
                  else {
                    return const Text('Empty data');
                  }
                }
                else {
                  return Text('State: ${snapshot.connectionState}');
                }
              },
            ),
        )
    );
  }

  List<GDPData> getChartData() {
    var color = Color.fromRGBO(30, 105, 205, 1);
    if(widget.client.currentUsage > widget.curGoal){
       color = Color.fromRGBO(242, 46, 46, 1);
    }
    else if (widget.client.currentUsage == widget.curGoal){
      color = Color.fromRGBO(30, 205, 95, 1);
    }

    final List<GDPData> chartData = [
      GDPData('Usage', widget.client.currentUsage, color)
    ];

    return chartData;
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.color);
  final String continent;
  final int gdp;
  final color;
}