import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:water_log_app/src/screens/home.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('Login'),),
      body: Column (
        children: [
          Container(
            //color: Color.fromARGB(255, 66, 165, 245),
            child: new Text(_errorMsg,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.red,
                  backgroundColor: Colors.redAccent.withOpacity(.25)
              ),
            ),
            alignment: Alignment(0.0, 0.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email'
              ),
              onChanged: (value){
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
              decoration: InputDecoration(
                hintText: 'Password'
              ),
              onChanged: (value){
                setState(() {
                  _password = value.trim();
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:[
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text('Signin'),
              onPressed: (){
                  auth.signInWithEmailAndPassword(email: _email, password: _password).then((res){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).catchError((error){
                    print("This is the Error: " + error.toString().split("]")[1]);
                    setState(() { _errorMsg = "Incorrect Email / Username combination "; });
                  });

              }),
            RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text('Signup'),
                onPressed: (){
                    auth.createUserWithEmailAndPassword(email: _email, password: _password);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                }),
          ])
        ]
      )
    );
  }
}


// void logInToFb() {
//   firebaseAuth
//       .signInWithEmailAndPassword(
//       email: emailController.text, password: passwordController.text)
//       .then((result) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => Home(uid: result.user.uid)),
//     );
//   }).catchError((err) {
//     print(err.message);
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Error"),
//             content: Text(err.message),
//             actions: [
//               TextButton(
//                 child: Text("Ok"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               )
//             ],
//           );
//         });
//   });
// }