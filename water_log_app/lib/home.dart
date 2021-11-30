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
    // _chartData = getChartData();
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
            FutureBuilder(
              future: getChartData(),
              builder: (
                  BuildContext context,
                  AsyncSnapshot< List<GDPData> > snapshot,
                  ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    throw Exception('Failed to get goal');
                  }
                  else if (snapshot.hasData) {
                    //widget.curGoal = jsonDecode(snapshot.data![0]!.body)[0]['GOAL'].toDouble();
                    _chartData = snapshot.data!;
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
                              "You are at: ${_chartData[0].gdp} out of ${widget.curGoal}",
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

  Future< List<GDPData> > getChartData() async {
    widget.curGoal = await getGoal(widget.client.userName);
    double cur = await getDay(widget.client.userName);
    var color = Color.fromRGBO(30, 105, 205, 1);
    if(cur > widget.curGoal){
       color = Color.fromRGBO(242, 46, 46, 1);
    }
    else if (cur == widget.curGoal){
      color = Color.fromRGBO(30, 205, 95, 1);
    }

    final List<GDPData> chartData = [
      GDPData('Usage', cur, color)
    ];

    return chartData;
  }
}

Future<double> getDay(String username) async {
  final response = await http.get(Uri.parse('http://10.11.25.60:443/api/cur_day_data/'+username));
  if (response.statusCode == 200) {
    if (jsonDecode(response.body)[0]["sum(amount)"] != null){
      return jsonDecode(response.body)[0]["sum(amount)"].toDouble();
    }
    return 0.0;
  }
  else {
    throw Exception('Failed to load user');
  }
}

Future<double> getGoal(String username) async {
  final response = await http.get(Uri.parse('http://10.11.25.60:443/api/cur_goals/'+username));
  if (response.statusCode == 200) {
    if (jsonDecode(response.body)[0]['GOAL'] != null){
      return jsonDecode(response.body)[0]['GOAL'].toDouble();
    }
    return 0.0;
  }
  else {
    throw Exception('Failed to load goal');
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.color);
  final String continent;
  final double gdp;
  final color;
}