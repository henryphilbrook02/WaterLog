import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:water_log_app/custom_theme.dart';
import 'package:water_log_app/models/userModel.dart' as userModel;


var user_name = "";
var name = "";
var weight = "";
var height = "";
var bmi = "";

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

  AccountPage({
    Key? key,
    required this.client
  }) : super(key: key);

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

  void postRequest() async {
    final response =
        await http.get(Uri.parse('http://10.11.25.60:443/api/users'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      // for (var i = 0; i < 2; i++) {
      //   x = User.fromJson(jsonDecode(response.body)[i]);
      //   debugPrint(x.userName.toString());
      // }
      var mainUser = User.fromJson(jsonDecode(response.body)[4]);

      setState(() {
        user_name = mainUser.userName.toString();
      });
      setState(() {
        weight = mainUser.weight.toString();
      });
      setState(() {
        height = mainUser.height.toString();
      });
      setState(() {
        bmi = mainUser.BMI.toString();
      });

      print("Username: " + user_name);
      //return User.fromJson(jsonDecode(response.body)[1]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    postRequest();

    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
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
                              'assets/images/tempUser.png'
                            ))
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
                              //color: Theme.of(context).scaffoldBackgroundColor,
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
              buildTextField("Username", user_name, false),
              buildTextField("Name", "John Maalouf", false),
              buildTextField("Email", "john.maalouf1@marist.edu", false),
              buildTextField("Date of Birth", "09/19/2000", false),
              buildTextField("Weight", weight, false),
              buildTextField("Height", height, false),
              buildTextField("BMI", bmi, false),
              buildTextField("Gender", "Male", false),
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
    postRequest();
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
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}

class User {
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
    return User(
      userName: json['USERNAME'],
      token: json['TOKEN'],
      weight: json['WEIGHT'],
      height: json['HEIGHT'],
      BMI: json['BMI'],
      currentUsage: json['CUR_USAGE'],
      //unit: json['UNIT'],
      creationDate: json['CREATION'],
      updateDate: json['LAST_UPDATE'],
    );
  }
}
