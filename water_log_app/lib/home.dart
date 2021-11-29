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
  var curGoal;

  homePage({
    Key? key,
    this.email,
    required this.client,
    required this.curGoal,
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
          title: Text("Welcome Back"),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child:  Column(
              children: <Widget>[
                Container (
                    height: 450,
                    child: SfCircularChart(
                      title: ChartTitle(text: 'Current Water Usage'),
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
                    "Current Goal: "+ widget.curGoal.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]
          )
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

Future<int> getCurGoal(String uname) async {
  final response =
  await http.get(Uri.parse('http://10.11.25.60:443/api/cur_goals/'+uname));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    var res = jsonDecode(response.body)[0];
    return res['GOAL'];

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to get goal');
  }
}