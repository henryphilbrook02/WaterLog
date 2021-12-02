import 'package:flutter/material.dart';
import 'package:water_log_app/main.dart';
import 'package:water_log_app/stats.dart';
import 'package:water_log_app/log_in.dart';
import 'package:water_log_app/friends.dart';
import 'package:water_log_app/models/userModel.dart' as userModel;
import 'package:water_log_app/friend_stats.dart';

class friends extends StatefulWidget {

  userModel.User client;

  friends({
    Key? key,
    required this.client
  }) : super(key: key);

  @override
  _friends createState() => _friends();
}

class _friends extends State<friends> {
  List<friendEntity> friendList = [
    friendEntity("Saqib", "Front End", false, false),
    friendEntity("Mike", "IT", false, false),
    friendEntity("Henry", "Back End", false, false),
    friendEntity("Jack", "Integration", false, false),
    friendEntity("Brian", "IS", false, false),
  ];

  List<friendEntity> friendRequestList = [
    friendEntity("Prof. Arias", "Professor", false, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        elevation: 1,
        automaticallyImplyLeading: false,
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
          SizedBox(
            width: double.infinity,
            height: 15,
          ),
          Row(
            children: <Widget>[
              const Expanded(child: Text("\t\t\tFriend Requests")),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 15,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: friendRequestList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.account_circle, size: 60),
                title: Text(friendRequestList[index].friendName,
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
                subtitle: Text(friendRequestList[index].friendDesc),
                trailing: FittedBox(
                  child: Row(
                    children: [
                      IconButton(
                          color: Colors.pinkAccent,
                          highlightColor: Colors.red.shade100,
                          splashRadius: 15,
                          onPressed: () {
                            setState(() {
                              friendRequestList[index].isFriend = false;
                              friendRequestList.removeAt(index);
                            });
                          },
                          icon: Icon(Icons.close_rounded)),
                      IconButton(
                          color: Colors.lightGreen,
                          highlightColor: Colors.green.shade100,
                          splashRadius: 15,
                          onPressed: () {
                            setState(() {
                              friendRequestList[index].isFriend = true;
                              addFriend(friendRequestList[index].friendName, friendRequestList[index].friendDesc, index);
                            });
                          },
                          //addFriend(friendRequestList[index].friendName, friendRequestList[index].friendDesc),
                          icon: Icon(Icons.check_rounded)),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(
            width: double.infinity,
            height: 15,
          ),
          Row(
            children: <Widget>[
              const Expanded(child: Text("\t\t\tFriends")),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 15,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: friendList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.account_circle, size: 60),
                title: Text(friendList[index].friendName,
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
                subtitle: Text(friendList[index].friendDesc),
                trailing: FittedBox(
                  child: Row(
                    children: [
                      IconButton(
                          color: Colors.lightGreen,
                          highlightColor: Colors.green.shade100,
                          splashRadius: 15,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => statsFriends()));
                          },
                          //addFriend(friendRequestList[index].friendName, friendRequestList[index].friendDesc),
                          icon: Icon(
                            Icons.account_box_outlined,
                            size: 35,
                          )),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void addFriend(String friendName, String friendDesc, int index) {
      setState(() {
        friendList.add(friendEntity(friendName, friendDesc, true, true));
        friendRequestList.removeAt(index);
    });
  }
}

class friendEntity {
  String friendName;
  String friendDesc;
  bool isFriend;
  bool friendStatus;

  friendEntity(
      this.friendName, this.friendDesc, this.isFriend, this.friendStatus);

}
