import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:water_log_app/globas.dart';

var sum = 0.0;
var day = "";
var myDay;
var fullAverage;
var gColor;
var mySums = [];
var myDays = [];

class Value {
  static String value = "Maaloufer";
  static void setString(String newValue) {
    value = newValue;
  }

  static String getString() {
    return value;
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.segmentColor);
  final String continent;
  final double gdp;
  final Color segmentColor;
}

Future<wData> postRequest() async {
  double average = 0;
  var http;
  final response = await http
      .get(Uri.parse('http://10.11.25.60:443/api/seven_day_readout/Maaloufer'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    // for (var i = 0; i < 2; i++) {
    //   x = User.fromJson(jsonDecode(response.body)[i]);
    //   debugPrint(x.userName.toString());
    // }
    for (var i = 0; i < 6; i++) {
      var mainUser = wData.fromJson(jsonDecode(response.body)[i]);
      sum = mainUser.wSum.toDouble();
      day = mainUser.wDay.toString();
      DateTime dt = DateTime.parse(day);
      myDay = DateFormat('EEEE').format(dt);

      mySums.add(sum);
      myDays.add(myDay);
      debugPrint("Average: " + average.toString());
      debugPrint("Sum: " + sum.toString());
      average = average + sum;

      debugPrint("I" + i.toString() + ": " + myDays[i].toString());
    }
    fullAverage = (average / 7);
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
