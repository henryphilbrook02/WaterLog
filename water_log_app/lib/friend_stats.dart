import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:water_log_app/models/userModel.dart' as userModel;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:water_log_app/models/userModel.dart' as userModel;
import 'package:water_log_app/custom_theme.dart';

var average = 0.0;
var totalNums = 2;
final now = new DateTime.now();
String formatter = DateFormat('yMd').format(now); // 28/03/2020

class statsFriends extends StatelessWidget {
  // This widget is the root of your application.

  String username;

  statsFriends({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePageFriends(username: username),
    );
  }
}

class MyHomePageFriends extends StatefulWidget {
  String username;

  MyHomePageFriends({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageFriends> {
  late List<GDPData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  bool showPassword = false;

  var sum = 0.0;
  var day = "";
  var myDay;
  var mySums = [];
  var myDays = [];
  var testAverage = 0;

  //  Need to use the passed username here
  Future<wData> postRequest() async {
    final response = await http.get(Uri.parse(
        'http://10.11.25.60:443/api/seven_day_readout/' + widget.username));
    average = 0;
    if (response.statusCode == 200) {
      for (var i = 0; i < 7; i++) {
        try {
          var mainUser = wData.fromJson(jsonDecode(response.body)[i]);
          sum = mainUser.wSum.toDouble();
          day = mainUser.wDay.toString();
          DateTime dt = DateTime.parse(day);
          myDay = DateFormat('EEEE').format(dt);
          average = average + sum;
          print("Average: " + average.toString());
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

  Widget build(BuildContext context) {
    print(widget.username);
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend Data"),
        elevation: 1,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        // image: DecorationImage(
                        //     fit: BoxFit.cover,
                        //     image: NetworkImage(
                        //       "C:\Users\saqib\Documents\GitHub\FormalLanguagesFinal\WaterLog\water_log_app\assets\images\newuser.png",
                        //     ))
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.blue,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              TextFormField(
                readOnly: true,
                enabled: false,
                decoration:
                    const InputDecoration(labelText: 'Username: Philbrooker'),
              ),
              TextFormField(
                readOnly: true,
                enabled: false,
                decoration: const InputDecoration(
                    labelText: 'Full Name: Henry Philbrook'),
              ),
              TextFormField(
                readOnly: true,
                enabled: false,
                decoration:
                    const InputDecoration(labelText: 'Age: 21 Years Old'),
              ),
              Container(
                height: 400,
                width: 400,
                child: buildGraph(context),
              ),
              SizedBox(
                height: 35,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        enabled: false,
        readOnly: true,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            //loatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  @override
  Widget buildGraph(BuildContext context) {
    print(formatter);
    // _chartData = getChartData();
    // _tooltipBehavior = TooltipBehavior(enable: true);
    return Scaffold(
      body: SfCartesianChart(
          title: ChartTitle(text: 'Weekly Water Usage'),
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries>[
            BarSeries<GDPData, String>(
                isTrackVisible: false,
                opacity: 0.5,
                color: const Color.fromRGBO(51, 153, 255, 255),
                name: "Average: " + (average / mySums.length).toString(),
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
              title: AxisTitle(text: 'Gallons Per Day - ' + formatter))),
    );
  }

  List<GDPData> getChartData() {
    final List<GDPData> chartData = [];

    try {
      for (int i = 0; i < mySums.length; i++) {
        var fullAverage = average / mySums.length;
        var lowerAverage = fullAverage - 10;
        var highAverage = fullAverage + 10;
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
      print("Error"); // only executed if error is of type Exception
    } catch (error) {
      print("Error"); // only executed if error is of type Exception
      // executed for errors of all types other than Exception
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
