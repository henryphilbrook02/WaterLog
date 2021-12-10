//
// Waterlog Capping Group
// Capping class Fall '21
// main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:water_log_app/account.dart';
import 'package:water_log_app/entity_creation.dart';
import 'package:water_log_app/stats.dart';
import 'package:water_log_app/log_in.dart';
import 'package:water_log_app/friends.dart';
import 'package:water_log_app/home.dart';
import 'package:water_log_app/friend_stats.dart';
import 'package:water_log_app/models/userModel.dart' as userModel;
// Imported Libraries

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class mainPage extends StatefulWidget {
  // Takes in the user from log in or new account
  final email;
  userModel.User client;
  mainPage({Key? key, this.email, required this.client}) : super(key: key);

  @override
  _mainPage createState() => _mainPage();
}

class _mainPage extends State<mainPage> {
  int selectedPage = 0;

  var _pageOptions = [];

  @override
  // Creates an array of the pages that are on the NAV bar
  void initState() {
    _pageOptions = [
      homePage(client: widget.client),
      stats(client: widget.client),
      EntityCreationItem(client: widget.client),
      friends(client: widget.client),
      AccountPage(client: widget.client),
    ]; // page options are for the navigation bar at the bottom, each page as their user passed into it
  }

  @override
  // This is the bottom of each page that allows the user to navigate to each section of the code
  Widget build(BuildContext context) {
    // Widget that contains the global nav bar
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
