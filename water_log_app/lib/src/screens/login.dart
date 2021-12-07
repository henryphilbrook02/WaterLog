import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:water_log_app/src/screens/home.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "";
  String _password = "";
  String _errorMsg = "";

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: Column(children: [
            Container(
              //color: Color.fromARGB(255, 66, 165, 245),
              child: new Text(
                _errorMsg,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.red,
                    backgroundColor: Colors.redAccent.withOpacity(.25)),
              ),
              alignment: Alignment(0.0, 0.0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('Signin'),
                  onPressed: () {
                    auth
                        .signInWithEmailAndPassword(
                            email: _email, password: _password)
                        .then((res) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    }).catchError((error) {
                      print("This is the Error: " +
                          error.toString().split("]")[1]);
                      setState(() {
                        _errorMsg = "Incorrect Email / Username combination ";
                      });
                    });
                  }),
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('Signup'),
                  onPressed: () {
                    auth.createUserWithEmailAndPassword(
                        email: _email, password: _password);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }),
            ])
          ])),
    );
  }
}

void postUser() async {
  print("user posted?");

  var uri = Uri.parse('http://10.11.25.60:443/api/users');

  Map<String, dynamic> map = {
    "id": "Jan",
    "tolken": "GIE A",
    "weight": 175,
    "height": "5 10",
    "BMI": 15,
    "curUsage": 65,
    "unit": "1",
    "email": "juan.arias@marist.edu",
    "creation": "2021-11-11",
    "update": "2021-11-11"
  };
  String rawJson = jsonEncode(map);

  http.Response response = await http.post(
    uri,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: rawJson,
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}
