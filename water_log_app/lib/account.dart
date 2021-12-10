//
// Waterlog Capping Group
// Capping class Fall '21
// Account.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:water_log_app/custom_theme.dart';
import 'package:water_log_app/log_in.dart';
import 'package:water_log_app/models/userModel.dart' as userModel;
import 'package:intl/intl.dart';

var user_name = "";
var name = "";
var weight = "";
var height = "";
var bmi = "";
String _errorMsg = "";

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme_class.light_theme,
      home: Account(),
    );
  }
}

class AccountPage extends StatefulWidget {
  userModel.User client;

  AccountPage({Key? key, required this.client}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool showPassword = false;

  String user_name = "";
  var name = "";
  var weight = "";
  var height = "";
  var bmi = "";
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final bmiController = TextEditingController();
  final genderController = TextEditingController();

  putRequest() async {
    // API put request to update user account information
    if (weightController.text == "" ||
        heightController.text == "" ||
        bmiController.text == "" ||
        genderController.text == "") {
      setState(() {
        _errorMsg = "Please Fill out all Fields";
      }); // checks if the fields are empty
    } else {
      Map<String, dynamic> map = {
        "token": " ",
        "weight": weightController.text,
        "height":
            heightController.text.replaceAll("\'", " ").replaceAll("\"", " "),
        "BMI": bmiController.text,
        "gender": genderController.text,
        "unit": "Metric",
        "email": widget.client.email,
        "creation": widget.client.creationDate.substring(0, 10),
        "update": widget.client.updateDate.substring(0, 10)
      };

      var uri = Uri.parse(
          'http://10.11.25.60:443/api/users/' + widget.client.userName);
      String rawJson = jsonEncode(map);

      http.Response response = await http.put(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: rawJson,
      );
      if (jsonDecode(response.body)["code"] == null) {
        setState(() {
          _errorMsg = "Success, changes will take effect after next log in";
        });
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget to build account
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => log_in(),
              ),
              (route) => false,
            );
          },
          child: Icon(
            Icons.logout, // add custom icons also
          ),
        ),
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
              Text(
                "View Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
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
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: new AssetImage(
                                  'assets/images/tempUser.png'))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              TextField(
                enabled: false,
                readOnly: true,
                controller: userNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Update Username? ',
                  labelText: 'Username: ' + widget.client.userName,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                enabled: false,
                readOnly: true,
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Update Email? ',
                  labelText: 'Email: ' + widget.client.email,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: weightController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Update Weight? ',
                  labelText: 'Weight: ' + widget.client.weight.toString(),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Update Height? ',
                  labelText: 'Height: ' + widget.client.height,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: bmiController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Update BMI? ',
                  labelText: 'BMI: ' + widget.client.BMI.toString(),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: genderController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Update Gender? ',
                  labelText: 'Gender: ' + widget.client.gender.toString(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              FlatButton(
                onPressed: () {
                  putRequest();
                },
                child: Text(
                  'Update Account Info',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Text(
                _errorMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.red,
                ),
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
}

class User {
  // User account class
  String userName;
  String token;
  int weight;
  String height;
  int BMI;
  int currentUsage;
  //int unit;
  String creationDate;
  String updateDate;

  User({
    required this.userName,
    required this.token,
    required this.weight,
    required this.height,
    required this.BMI,
    required this.currentUsage,
    //required this.unit,
    required this.creationDate,
    required this.updateDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Parse information
    return User(
      userName: json['USERNAME'],
      token: json['TOKEN'],
      weight: json['WEIGHT'],
      height: json['HEIGHT'],
      BMI: json['BMI'],
      currentUsage: json['CUR_USAGE'],
      creationDate: json['CREATION'],
      updateDate: json['LAST_UPDATE'],
    );
  }
}
