//
// Waterlog Capping Group
// Capping class Fall '21
// new_user.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:water_log_app/models/userModel.dart' as Client;
import 'main.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App with MYSQL',
      home: new NewUserPage(),
    );
  }
}

class NewUserPage extends StatefulWidget {
  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  bool validPassword = false;
  final auth = FirebaseAuth.instance;

  String _errorMsg = "";

  String _name = "";
  String _email = "";
  String _password = "";
  String _gender = "Gender";
  String _height = "";
  String _unit = "Unit";
  int _weight = 0;
  int _BMI = 0;
  int _goal = 0;

  newUser() async {
    // creates user instance based on input of the user
    Client.User newUser = Client.User(
        userName: _name,
        token: "",
        weight: _weight,
        height: _height,
        BMI: _BMI,
        gender: _gender,
        unit: _unit,
        email: _email,
        creationDate: "2021-11-11",
        updateDate: "2021-11-11");
    var uri = Uri.parse('http://10.11.25.60:443/api/users');
    String rawJson = jsonEncode(newUser.getapiBody());
    http.Response response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: rawJson,
    );
    if (jsonDecode(response.body)["code"] == null) {
      print("Made it past the null check: " + response.body);
      return newUser;
    } else {
      print("bad data: " + response.body);
      return null;
    }
  }

  // Creates the goal for the user after input
  newGoal(Client.User newUser) async {
    Map<String, dynamic> map = {
      "username": newUser.userName,
      "goal": _goal,
      "current": 1,
      "creation": "2021-11-11",
    };

    var uri = Uri.parse('http://10.11.25.60:443/api/goals');
    String rawJson = jsonEncode(map);

    http.Response response = await http.post(
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

  // Makes sure that the password is semi-complex
  validateTextField(String userInput) {
    if (userInput.length >= 8 &&
        (userInput.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]')))) {
      setState(() {
        validPassword = false;
      });
      return true;
    } else {
      setState(() {
        validPassword = true;
      });
      return false;
    }
  }

  @override
  // Builds all the imput boxes that the user needs to fill out
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: new EdgeInsets.only(
          top: 20.0,
          right: 40.0,
          left: 40.0,
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/newuser.png'),
              TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Your Username',
                    hintStyle: TextStyle(color: Colors.blue),
                    contentPadding: EdgeInsets.all(10),
                    constraints: BoxConstraints.tightFor(width: 350),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value.trim();
                    });
                  }),
              SizedBox(height: 8.0),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@mail.com',
                    hintStyle: TextStyle(color: Colors.blue),
                    contentPadding: EdgeInsets.all(10),
                    constraints: BoxConstraints.tightFor(width: 350),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  }),
              SizedBox(height: 8.0),
              TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    errorText:
                        validPassword ? 'Please enter a valid password' : null,
                    labelText: 'Password',
                    hintText: '8 characters long with Symbol',
                    hintStyle: TextStyle(color: Colors.blue),
                    contentPadding: EdgeInsets.all(10),
                    constraints: BoxConstraints.tightFor(width: 350),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });
                  }),
              SizedBox(height: 8.0),
              DropdownButton<String>(
                value: _gender,
                icon: Icon(Icons.keyboard_arrow_down),
                items:
                    <String>['Gender', 'M', 'F', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),

              SizedBox(height: 8.0),
              DropdownButton<String>(
                value: _unit,
                icon: Icon(Icons.keyboard_arrow_down),
                items:
                    <String>['Unit', 'Metric', 'Imperial'].map((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _unit = value!;
                  });
                },
              ),
              SizedBox(height: 8.0),
              TextField(
                  decoration: InputDecoration(
                    labelText: 'Height',
                    hintText: "Ex: 5'8",
                    hintStyle: TextStyle(color: Colors.blue),
                    contentPadding: EdgeInsets.all(10),
                    constraints: BoxConstraints.tightFor(width: 350),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _height = value
                          .trim()
                          .replaceAll("\'", " ")
                          .replaceAll("\"", " ");
                    });
                  }),
              SizedBox(height: 8.0),
              TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Weight',
                    hintText: 'Ex: 160 ',
                    hintStyle: TextStyle(color: Colors.blue),
                    contentPadding: EdgeInsets.all(10),
                    constraints: BoxConstraints.tightFor(width: 350),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    setState(() {
                      _weight = int.parse(value);
                    });
                  }),
              SizedBox(height: 8.0),
              TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'BMI',
                    hintText: 'Ex: 28 ',
                    hintStyle: TextStyle(color: Colors.blue),
                    contentPadding: EdgeInsets.all(10),
                    constraints: BoxConstraints.tightFor(width: 350),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    setState(() {
                      _BMI = int.parse(value);
                    });
                  }),
              SizedBox(height: 8.0),
              TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Goal',
                    hintText: 'Ex: 105 ',
                    hintStyle: TextStyle(color: Colors.blue),
                    contentPadding: EdgeInsets.all(10),
                    constraints: BoxConstraints.tightFor(width: 350),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    setState(() {
                      _goal = int.parse(value);
                    });
                  }),
              SizedBox(height: 8.0),
              //This is the submit button that will check if the password, username, and email are valid along with the other fields
              MaterialButton(
                minWidth: 200.0,
                height: 40.0,
                child: Text("Register"),
                color: Colors.blue,
                elevation: 5,
                onPressed: () async {
                  if (validateTextField(_password)) {
                    Client.User user = await newUser();
                    print(user != null);
                    if (user != null) {
                      if (await newGoal(user)) {
                        auth
                            .createUserWithEmailAndPassword(
                                email: _email, password: _password)
                            .then((res) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      new mainPage(client: user)));
                        }).catchError((error) {
                          print("This is the Error: " +
                              error.toString().split("]")[1]);
                          setState(() {
                            _errorMsg = "Firebase error";
                          });
                        });
                      } else {
                        setState(() {
                          _errorMsg = "Goal Error";
                        });
                        print("Goal Error");
                      }
                    } else {
                      setState(() {
                        _errorMsg = "userError";
                      });
                      print("userError");
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
