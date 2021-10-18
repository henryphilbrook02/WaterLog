import 'package:flutter/material.dart';
import 'package:water_log_app/main.dart';
import 'package:water_log_app/stats.dart';
import 'package:water_log_app/log_in.dart';
import 'package:water_log_app/friends.dart';

class friends extends StatefulWidget {
  @override
  _friends createState() => _friends();
}

class _friends extends State<friends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          Container(
            width: 1,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search Friends',
              ),
            ),
          ),
          SizedBox(height: 30),
          ListTile(
            leading: Icon(Icons.account_circle, size: 60),
            title: Text(
              'Jack',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 15),
          ListTile(
            leading: Icon(Icons.account_circle, size: 60),
            title: Text(
              'Henry',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 15),
          ListTile(
            leading: Icon(Icons.account_circle, size: 60),
            title: Text(
              'Mike',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 15),
          ListTile(
            leading: Icon(Icons.account_circle, size: 60),
            title: Text(
              'Brian',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 15),
          ListTile(
            leading: Icon(Icons.account_circle, size: 60),
            title: Text(
              'Saqib',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 15),
          ListTile(
            leading: Icon(Icons.account_circle, size: 60),
            title: Text(
              'Prof. Arias',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
