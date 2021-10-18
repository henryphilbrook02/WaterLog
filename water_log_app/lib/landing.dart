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
        children: const <Widget>[
          ListTile(
            leading: Icon(Icons.account_circle, size: 60),
            title: Text(
              'Map',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.photo_album),
            title: Text('Album'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone'),
          ),
        ],
      ),
    );
  }
}
