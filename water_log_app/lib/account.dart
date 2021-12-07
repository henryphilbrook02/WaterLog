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
String _errorMsg = " ";

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

  postRequest() async {
    if (weightController.text == "" ||
        heightController.text == "" ||
        bmiController.text == "" ||
        genderController.text == "") {
      setState(() {
        _errorMsg = "Please Fill out all Fields";
      });
    } else {
      Map<String, dynamic> map = {
        "token": " ",
        "weight": weightController.text,
        "height": heightController.text,
        "BMI": bmiController.text,
        "gender": genderController.text,
        "unit": "Metric",
        "email": widget.client.email,
        "creation": "2021-11-11",
        "update": "2021-11-11"
      };

      print("WEIGHT " +
          weightController.text +
          " HEIGHT " +
          heightController.text +
          " BMI " +
          bmiController.text +
          " GENDER " +
          genderController.text +
          " EMAIL " +
          emailController.text +
          " REATION " +
          widget.client.creationDate +
          " LAST_UPDATE " +
          widget.client.updateDate);

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
      print("Made it past the null check: " + response.body);
      if (jsonDecode(response.body)["code"] == null) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //postRequest();

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
                                  'assets/images/tempUser.png'))),
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
                controller: weightController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Update Weight? ',
                  labelText: 'Weight: ' + widget.client.weight.toString(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: heightController,
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
                controller: bmiController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Update BMI? ',
                  labelText: 'BMI: ' + widget.client.BMI.toString(),
                ),
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
                  postRequest();
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
                    backgroundColor: Colors.redAccent.withOpacity(.25)),
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

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField, TextEditingController myController) {
    //postRequest();
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
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
        controller: myController,
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
      creationDate: json['CREATION'],
      updateDate: json['LAST_UPDATE'],
    );
  }
}
