import 'package:flutter/material.dart';
import 'package:water_log_app/main.dart';
import 'package:water_log_app/stats.dart';
import 'package:water_log_app/log_in.dart';
import 'package:water_log_app/friends.dart';
import 'package:water_log_app/friendEntity.dart';

class friends extends StatefulWidget {
  @override
  _friends createState() => _friends();
}

class _friends extends State<friends> {

  List<friendEntity> friendList = [
    friendEntity("Saqib", "Front End", false, false),
    friendEntity("Mike", "Integration", false, false),
    friendEntity("Henry", "Back End", false, false),
    friendEntity("Jack", "IT", false, false),
    friendEntity("Brian", "IS", false, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        elevation: 1,
      ),
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
          ListView.builder(
            itemCount: friendList.length,
            itemBuilder: (context, index) {
              return ListTile(
              leading: Icon(Icons.account_circle, size: 60),
              title: Text(
                friendList[index].friendName,
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
              subtitle: Text(friendList[index].friendDesc),
              trailing: FittedBox(
                child: Row(
                  children: [
                    IconButton(
                      color: Colors.pinkAccent,
                      highlightColor: Colors.red.shade100,
                      splashRadius: 15,
                      onPressed: () { setState( () {friendList[index].isFriend = false;} ); },
                      /*
                        Not sure how to fix this, not sure what state I need to change here
                        I know this has to decrement the quantity of water used.
                      */
                      icon: Icon(Icons.close_rounded)
                      ),
                    IconButton(
                      color: Colors.lightGreen,
                      highlightColor: Colors.green.shade100,
                      splashRadius: 15,
                      onPressed: () { setState( () {friendList[index].isFriend = true;;} ); },
                      /*
                        Not sure how to fix this, not sure what state I need to change here
                        I know this has to decrement the quantity of water used.
                      */
                      icon: Icon(Icons.check_rounded)
                      ),
                  ],
                ),
              ),
            );
            },
          ),
          SizedBox(height: 30),
          //friendBar("Jack", "Amazing Integration Dude", false),
          SizedBox(height: 15),
          //friendBar("Henry", "Amazing Back End Dude", false),
          SizedBox(height: 15),
          //friendBar("Mike", "Amazing IT Dude", false),
          SizedBox(height: 15),
          //friendBar("Brian ", "Amazing IS Dude", false),
          SizedBox(height: 15),
          //friendBar("Saqib", "Amazing Front End Dude", false),
          SizedBox(height: 15),
          //friendBar("Prof. Arias", "Amazing Professor", false),
        ],
      ),
    );
  }

 Widget friendBar (String friendName, String bio, bool isFriend) {
  return ListTile(
    leading: Icon(Icons.account_circle, size: 60),
    title: Text(
      friendName,
      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
    subtitle: Text(bio),
    trailing: FittedBox(
      child: Row(
        children: [
          IconButton(
            color: Colors.pinkAccent,
            highlightColor: Colors.red.shade100,
            splashRadius: 15,
            onPressed: () { setState( () {isFriend = false;} ); },
            /*
              Not sure how to fix this, not sure what state I need to change here
              I know this has to decrement the quantity of water used.
            */
            icon: Icon(Icons.close_rounded)
            ),
          IconButton(
            color: Colors.lightGreen,
            highlightColor: Colors.green.shade100,
            splashRadius: 15,
            onPressed: () { setState( () {isFriend = true;;} ); },
            /*
              Not sure how to fix this, not sure what state I need to change here
              I know this has to decrement the quantity of water used.
            */
            icon: Icon(Icons.check_rounded)
            ),
        ],
      ),
    ),
  );
}

}
