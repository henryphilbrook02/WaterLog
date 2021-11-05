import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:water_log_app/custom_theme.dart';
import 'package:water_log_app/log_in.dart';
import 'package:water_log_app/new_user.dart';
import 'package:water_log_app/stats.dart';
import 'package:water_log_app/main.dart';

import 'package:http/http.dart' as http;

import 'account.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme_class.light_theme,
      home: log_in(),
    );
  }
}

class log_in extends StatefulWidget {
  @override
  log_in_state createState() => log_in_state();
}

class log_in_state extends State<log_in> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 150,
                  /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                  // TODO ADD IMAGE HERE child: Image.asset('ADD ASSET HERE')
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            FlatButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => mainPage()),
                  );
                  postRequest();
                  // var x = http.get(Uri.parse('http://10.0.2.2:8080/api/users'));
                  // debugPrint(jsonDecode(x.toString()));

                  /*
                  

                  */
                },
                child: Text(
                  'PrintToConsole',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewUserPage()),
                );
              },
              child: Text(
                'New User? Create Account',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<User> postRequest() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8080/api/users'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      debugPrint(User.fromJson(jsonDecode(response.body)).getUserName());
      return User.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Users');
    }
  }

//   postRequest() async {
//     debugPrint("Made it");
//     // todo - fix baseUrl
//     var url = 'http://10.0.2.2:8080/api/users';
//     // var body = json.encode({
//     //   'nick': nick,
//     //   'password': password,
//     // });

//     // print('Body: $body');

//     var response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'accept': 'application/json',
//         'Content-Type': 'application/json-patch+json',
//       },
//     );

//     // todo - handle non-200 status code, etc

//     debugPrint(json.decode(response.body));
//   }
}

class User {
  String userName;
  String token;
  int weight;
  String height;
  int BMI;
  int currentUsage;
  int unit;
  String creationDate;
  String updateDate;

  User({
    required this.userName,
    required this.token,
    required this.weight,
    required this.height,
    required this.BMI,
    required this.currentUsage,
    required this.unit,
    required this.creationDate,
    required this.updateDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['userName'],
      token: json['token'],
      weight: json['weight'],
      height: json['height'],
      BMI: json['BMI'],
      currentUsage: json['currentUsage'],
      unit: json['unit'],
      creationDate: json['creationDate'],
      updateDate: json['updateDate'],
    );
  }
  getUserName() {
    return userName;
  }
}
