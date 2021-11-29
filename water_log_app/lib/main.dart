import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:water_log_app/account.dart';
import 'package:water_log_app/entity_creation.dart';
import 'package:water_log_app/stats.dart';
import 'package:water_log_app/log_in.dart';
import 'package:water_log_app/friends.dart';
import 'package:water_log_app/home.dart';
import 'package:water_log_app/friend_stats.dart';
import 'package:http/http.dart' as http;
import 'package:water_log_app/models/userModel.dart' as userModel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class mainPage extends StatefulWidget {

  final email;
  userModel.User client;

  mainPage({
    Key? key,
    this.email,
    required this.client
  }) : super(key: key);

  @override
  _mainPage createState() => _mainPage();
}

class _mainPage extends State<mainPage> {

  int selectedPage = 0;

  var _pageOptions = [];

  @override
  void initState() {

    double temp = 10.0;

    _pageOptions = [
      homePage(client: widget.client, curGoal: temp),
      stats(),
      EntityCreationItem(),
      friends(),
      AccountPage(),
      statsFriends(),
    ];

    Future.delayed(Duration.zero, () async {

      double temp = (await getCurGoal(widget.client.userName)).toDouble();

      //print(temp);
      setState(() {
        _pageOptions = [
          homePage(client: widget.client, curGoal: temp),
          stats(),
          EntityCreationItem(),
          friends(),
          AccountPage(),
          statsFriends(),
        ];
      });

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _pageOptions[selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart, size: 30), title: Text('Stats')),
            BottomNavigationBarItem(
                icon: Icon(Icons.add, size: 30), title: Text('Add Water')),
            BottomNavigationBarItem(
                icon: Icon(Icons.group, size: 30), title: Text('Friends')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, size: 30),
                title: Text('Profile')),
          ],
          selectedItemColor: Colors.green,
          elevation: 5.0,
          unselectedItemColor: Colors.green[900],
          currentIndex: selectedPage,
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              selectedPage = index;
            });
          },
        ));
  }
}


Future<int> getCurGoal(String uname) async {
  final response =
  await http.get(Uri.parse('http://10.11.25.60:443/api/cur_goals/'+uname));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    var res = jsonDecode(response.body)[0];
    return res['GOAL'];

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to get goal');
  }
}