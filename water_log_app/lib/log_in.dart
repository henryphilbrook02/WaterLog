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

import 'package:water_log_app/models/userModel.dart' as userModel;

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
  var client;

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
            Center(
              child:
              Image(image: AssetImage("assets/images/waterlog.png")),
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
                    Future.delayed(Duration.zero, () async {
                      var user = await postRequest(_email);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => new mainPage(client: user)));
                    });
                  }).catchError((error){
                    print("This is the Error: " + error.toString().split("]")[1]);
                    setState(() { _errorMsg = "Incorrect Email / Username combination "; });
                  });
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 100,
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
}

Future<userModel.User> postRequest(String email) async {
  final response =
  await http.get(Uri.parse('http://10.11.25.60:443/api/user/'+email));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    var res = jsonDecode(response.body)[0];

    userModel.User client = new userModel.User(
        userName: res['USERNAME'],
        token: res['TOKEN'],
        weight: res['WEIGHT'],
        height: res['HEIGHT'],
        BMI: res['BMI'],
        currentUsage: res['CUR_USAGE'],
        unit: res['UNIT'],
        email: res['EMAIL'],
        creationDate: res['CREATION'],
        updateDate: res['LAST_UPDATE']
    );

    return client;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
