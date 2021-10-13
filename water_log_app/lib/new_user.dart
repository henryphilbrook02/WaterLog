import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController dob = new TextEditingController();
  TextEditingController height = new TextEditingController();
  TextEditingController weight = new TextEditingController();

  void post() async {
    print("Made it to method");
    final response = await http
        .post(Uri.parse("http://192.168.0.174/MealTimeServer/config.php"), body: {
      "name": name.text,
      "email": email.text,
      "password": password.text,
      "dob": dob.text,
      "height": height.text,
      "weight": weight.text,
    });
    print("completed Method");
  }

  void validateTextField(String userInput) {
    if (userInput.length >= 8 &&
        (userInput.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]')))) {
      setState(() {
        validPassword = false;
      });
    } else {
      setState(() {
        validPassword = true;
      });
    }
  }

  @override
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
                controller: name,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Your Username:',
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.all(10),
                  constraints: BoxConstraints.tightFor(width: 350),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'example@mail.com:',
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.all(10),
                  constraints: BoxConstraints.tightFor(width: 350),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: password,
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
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: dob,
                decoration: InputDecoration(
                  labelText: 'Date Of Birth: ',
                  hintText: 'dd/mm/yyyy:',
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.all(10),
                  constraints: BoxConstraints.tightFor(width: 350),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: height,
                decoration: InputDecoration(
                  labelText: 'Height',
                  hintText: "Ex: 5'8:",
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.all(10),
                  constraints: BoxConstraints.tightFor(width: 350),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: weight,
                decoration: InputDecoration(
                  labelText: 'Weight',
                  hintText: 'Ex: 160: ',
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.all(10),
                  constraints: BoxConstraints.tightFor(width: 350),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              MaterialButton(
                minWidth: 200.0,
                height: 40.0,
                child: Text("Register"),
                color: Colors.blue,
                elevation: 5,
                onPressed: () {
                  validateTextField(password.text);
                  post();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
