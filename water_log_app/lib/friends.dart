import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:water_log_app/models/userModel.dart' as userModel;
import 'package:water_log_app/friend_stats.dart';
import 'package:http/http.dart' as http;


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

  List<friendEntity> friendList = [];

  List<friendEntity> friendRequestList = [];

  final appbar = AppBar(
  title: Text("Friends"),
  elevation: 1,
  automaticallyImplyLeading: false,
  );

  @override
  Widget build(BuildContext context) {
    final appbarHeight = appbar.preferredSize.height;
    return Scaffold(
      appBar: appbar,
      backgroundColor: Colors.white,
      body:
        FutureBuilder <List<List<friendEntity>>>(
          future: Future.wait([
            getFriends(widget.client.userName),
            getRequests(widget.client.userName),
        ]), builder: (
            BuildContext context,
            AsyncSnapshot<List<List<friendEntity>>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print(snapshot.error);
              throw Exception('Failed to get goal');
            }
            else if (snapshot.hasData) {

              friendList = snapshot.data![0];
              friendList.add(friendEntity("name1"));
              friendList.add(friendEntity("name2"));
              friendList.add(friendEntity("name3"));
              friendList.add(friendEntity("name4"));
              friendList.add(friendEntity("name5"));
              friendList.add(friendEntity("name6"));
              friendList.add(friendEntity("name7"));
              friendList.add(friendEntity("name8"));
              friendList.add(friendEntity("name9"));
              friendList.add(friendEntity("name10"));
              friendRequestList = snapshot.data![1];
              print(friendRequestList.length);
              final screenHeight = MediaQuery.of(context).size.height;
              return
                SingleChildScrollView(
                  child: SizedBox(
                      height: screenHeight-appbarHeight - 125,
                      child: ListView(
                        //scrollDirection: Axis.vertical,
                        children: <Widget>[
                          SizedBox(height: 5),
                          const SizedBox(
                            width: double.infinity,
                            height: 5,
                          ),
                      Row(
                        children: const <Widget>[
                          Expanded(child: Text("\t\t\tFriend Requests")),
                        ],
                      ),
                      const SizedBox(
                        width: double.infinity,
                        height: 15,
                      ),
                      // TODO make this be gone when length is 0
                          ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: friendRequestList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.account_circle, size: 60),
                          title: Text(friendRequestList[index].username,
                              style:
                              TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
                          subtitle: Text(friendRequestList[index].username),
                          trailing: FittedBox(
                            child: Row(
                              children: [
                                IconButton(
                                    color: Colors.pinkAccent,
                                    highlightColor: Colors.red.shade100,
                                    splashRadius: 15,
                                    onPressed: () {
                                      setState(() {
                                        // TODO remove the friend invite
                                        friendRequestList.removeAt(index);
                                      });
                                    },
                                    icon: Icon(Icons.close_rounded)),
                                IconButton(
                                    color: Colors.lightGreen,
                                    highlightColor: Colors.green.shade100,
                                    splashRadius: 15,
                                    onPressed: () {
                                      // TODO made this send an api call to edit the invite
                                      setState(() {
                                        addFriend(friendRequestList[index].username, index);
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
                  const SizedBox(
                    width: double.infinity,
                    height: 15,
                  ),
                  Row(
                    children: const <Widget>[
                      Expanded(child: Text("\t\t\tFriends")),
                    ],
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 15,
                  ),
                  ListView.builder(
                    //scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: friendList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.account_circle, size: 60),
                        title: Text(friendList[index].username,
                            style:
                            TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
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
                                            builder: (context) => statsFriends( username: friendList[index].username )));
                                  },
                                  //addFriend(friendRequestList[index].friendName, friendRequestList[index].friendDesc),
                                  icon: const Icon(
                                    Icons.account_box_outlined,
                                    size: 35,
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],)));
            }
            else {
              return const Text('Empty data');
            }
          }
          else {
            return Text('State: ${snapshot.connectionState}');
          }
        }
        )
      );
  }

  void addFriend(String friendName, int index) {
      setState(() {
        friendList.add(friendEntity(friendName));
        friendRequestList.removeAt(index);
    });
  }
}

class friendEntity {
  String username;

  friendEntity(
      this.username);
}

Future<List<friendEntity>> getFriends(String uName) async {
  final response =
  await http.get(Uri.parse('http://10.11.25.60:443/api/ufs/'+uName));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    List<friendEntity> friendList = [];

    for (int i = 0; i<jsonDecode(response.body).length; i++){
      var reqed = jsonDecode(response.body)[i]['REQUESTED'];
      var reqee = jsonDecode(response.body)[i]['REQUESTEE'];
      if (reqed == uName){
        friendList.add(friendEntity(reqee));
      }
      else{
        friendList.add(friendEntity(reqed));
      }

    }

    return friendList;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<friendEntity>> getRequests(String uName) async {
  final response =
  await http.get(Uri.parse('http://10.11.25.60:443/api/pfs/'+uName));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    List<friendEntity> pendingFriendList = [];

    for (int i = 0; i<jsonDecode(response.body).length; i++){

      pendingFriendList.add(friendEntity(jsonDecode(response.body)[i]['REQUESTEE']));

    }


    return pendingFriendList;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}