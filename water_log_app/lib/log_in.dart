import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
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
  String _email = "";
  String _password = "";
  String _errorMsg = "";

  final auth = FirebaseAuth.instance;

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
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'
                ),
                onChanged: (value){
                  setState(() {
                    _email = value.trim();
                  });
                },
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
                    hintText: 'Enter secure password'
                ),
                onChanged: (value){
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
            ),
            // FlatButton(
            //   onPressed: () {
            //     //TODO FORGOT PASSWORD SCREEN GOES HERE
            //   },
            //   child: Text(
            //     'Forgot Password',
            //     style: TextStyle(color: Colors.blue, fontSize: 15),
            //   ),
            // ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
              child: new Text(_errorMsg,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.red,
                    backgroundColor: Colors.redAccent.withOpacity(.25)
                ),
              ),
              alignment: Alignment(0.0, 0.0),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  auth.signInWithEmailAndPassword(email: _email, password: _password).then((res){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => new mainPage(email: _email)));
                  }).catchError((error){
                    print("This is the Error: " + error.toString().split("]")[1]);
                    setState(() { _errorMsg = "Incorrect Email / Username combination "; });
                  });

                  // TODO get data from the databse so we know the user i think the res we get can give us the email
                  // postRequest();
                  // var x = http.get(Uri.parse('http://10.0.2.2:8080/api/users'));
                  // debugPrint(jsonDecode(x.toString()));

                },
                child: Text(
                  'Login',
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

      for (var i = 0; i < 2; i++) {
        var x = User.fromJson(jsonDecode(response.body)[i]);
        debugPrint(x.userName.toString());
      }

      return User.fromJson(jsonDecode(response.body)[0]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
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
  getUserName() {
    return userName;
  }
}
