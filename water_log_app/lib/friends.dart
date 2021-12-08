import 'dart:convert';
import 'dart:io';
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

  String _name = "";

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

              friendRequestList = snapshot.data![1];

              bool isVisible;
              if (friendRequestList.length == 0){
                isVisible = false;
              }
              else{
                isVisible = true;
              }

              print(friendRequestList.length);
              final screenHeight = MediaQuery.of(context).size.height;
              var _controller = TextEditingController();
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
                          TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                hintText: 'Friend Username',
                                hintStyle: TextStyle(color: Colors.blue),
                                contentPadding: EdgeInsets.all(10),
                                constraints: BoxConstraints.tightFor(width: 350),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) {
                                _name = value.trim();
                              }
                          ),
                          FlatButton(
                            color: Colors.blue,
                            splashColor: Colors.white,
                            onPressed: () async {
                              _controller.clear();
                              _showAlertDialog(await sendRequest(widget.client.userName, _name));
                            },
                            child: Text("Add Friend",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                      Visibility(
                        visible: isVisible,
                        child: Row(
                        children: const <Widget>[
                          Expanded(child: Text("\t\t\tFriend Requests")),
                        ],
                      )),
                      const SizedBox(
                        width: double.infinity,
                        height: 15,
                      ),
                      Visibility(
                        visible: isVisible,
                          child: ListView.builder(
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
                                    onPressed: () async{
                                      await deleteReq(friendRequestList[index].fID);
                                      setState(()  {
                                        friendRequestList.removeAt(index);
                                      });
                                    },
                                    icon: Icon(Icons.close_rounded)),
                                IconButton(
                                    color: Colors.lightGreen,
                                    highlightColor: Colors.green.shade100,
                                    splashRadius: 15,
                                    onPressed: () async{
                                      await acceptFriendship(friendRequestList[index].fID);
                                      setState(() {
                                        addFriend(friendRequestList[index].username, index, friendRequestList[index].fID);
                                      });
                                    },
                                    //addFriend(friendRequestList[index].friendName, friendRequestList[index].friendDesc),
                                    icon: Icon(Icons.check_rounded)),
                              ],
                            ),
                          ),
                        );
                        },
                        )),
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

  void _showAlertDialog(String newDesc) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(newDesc),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  void addFriend(String friendName, int index, int fID) {
      setState(() {
        friendList.add(friendEntity(friendName, fID));
        friendRequestList.removeAt(index);
    });
  }
}

class friendEntity {
  String username;
  int fID;

  friendEntity(this.username, this.fID);
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
        friendList.add(friendEntity(reqee, jsonDecode(response.body)[i]['FS_ID']));
      }
      else{
        friendList.add(friendEntity(reqed, jsonDecode(response.body)[i]['FS_ID']));
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

      pendingFriendList.add(friendEntity(jsonDecode(response.body)[i]['REQUESTEE'],
          jsonDecode(response.body)[i]['FS_ID']));

    }


    return pendingFriendList;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}


Future<String> sendRequest(String client, String newFriend ) async {
  var uri = Uri.parse('http://10.11.25.60:443/api/fs/');

  if (newFriend == client){
    return "Cannot Add Yourself";
  }

  Map<String, dynamic> map = {
    "requested": newFriend,
    "requestee": client,
    "accepted": 0,
    "creation": "2021-11-01",
    "update": "2021-11-01"
  };
  String rawJson = jsonEncode(map);

  http.Response response = await http.post(
    uri,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: rawJson,
  );

  if (jsonDecode(response.body)["code"] == null){
    print("Made it past the null check: " + response.body);
    return "Friend Request Sent!";
  }
  else{
    print("bad data: " + response.body);
    return "Cannot Add That User";
  }

}


Future acceptFriendship(int fID) async {
  var uri = Uri.parse('http://10.11.25.60:443/api/pfs/${fID}');

  Map<String, dynamic> map = {
    "accepted": 1, // amount
  };
  String rawJson = jsonEncode(map);

  http.Response response = await http.put(
    uri,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: rawJson,
  );

  return response;

}

Future deleteReq(int fID) async {
  var uri = Uri.parse('http://10.11.25.60:443/api/fs/$fID');

  http.Response response = await http.delete(uri);

  return response;
}