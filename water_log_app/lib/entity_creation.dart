import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:water_log_app/custom_theme.dart';
import 'package:http/http.dart' as http;
import 'package:water_log_app/models/userModel.dart' as userModel;

final now = new DateTime.now();
String formatter = DateFormat('yyyy-MM-dd').format(now); // 28/03/2020
var currentDate = formatter.replaceAll("/", "-");

class EntityCreation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme_class.light_theme,
      home: EntityCreation(),
    );
  }
}

class EntityCreationItem extends StatefulWidget {
  userModel.User client;

  EntityCreationItem({Key? key, required this.client}) : super(key: key);

  @override
  _EntityCreationPageState createState() => _EntityCreationPageState();
}

class _EntityCreationPageState extends State<EntityCreationItem> {
  Future<entityData> postRequest() async {
    final response =
        await http.get(Uri.parse('http://10.11.25.60:443/api/activities'));
    if (response.statusCode == 200) {
      try {
        for (var i = 0; i < 10; i++) {
          var mainUser = entityData.fromJson(jsonDecode(response.body)[i]);
          var activityName = mainUser.NAME.toString();
          var activityUnit = mainUser.UNIT.toString();
          var activityAmount = mainUser.AMOUNT;

          addEntity(activityName, activityUnit, activityAmount);
        }
      } on Exception catch (exception) {
        print("Error");
      } catch (error) {
        print("Error");
        // executed for errors of all types other than Exception
      }

      return entityData.fromJson(jsonDecode(response.body)[0]);
    } else {
      throw Exception('Failed to load user');
    }
  }

  List<Entity> entityList = [];

  late TextEditingController _Activity;
  late TextEditingController _Desc;
  late TextEditingController _Amount;
  initState() {
    _Activity = new TextEditingController();
    _Desc = new TextEditingController();
    _Amount = new TextEditingController();
    Future.delayed(Duration.zero, () async {
      await postRequest();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Your Water Intake"),
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              itemCount: entityList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.water),
                  title: Text(entityList[index].entityName),
                  subtitle: Text(entityList[index].desc),
                  trailing: FittedBox(
                    child: Row(
                      children: [
                        IconButton(
                            color: Colors.black,
                            highlightColor: Colors.red.shade100,
                            splashRadius: 15,
                            onPressed: () {
                              setState(() {
                                entityList[index].waterUnits != 0
                                    ? entityList[index].waterUnits--
                                    : entityList[index].waterUnits;
                              });
                            },
                            icon: Icon(Icons.remove)),
                        Text(entityList[index].waterUnits.toString()),
                        IconButton(
                            color: Colors.black,
                            highlightColor: Colors.green.shade100,
                            splashRadius: 15,
                            onPressed: () {
                              setState(() {
                                entityList[index].waterUnits != -1
                                    ? entityList[index].waterUnits++
                                    : entityList[index].waterUnits;
                              });
                            },
                            icon: Icon(Icons.add)),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
          height: 50,
          width: 300,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          child: FloatingActionButton.extended(
            onPressed: () {
              postEntry();
              print("submit");
            },
            label: const Text("Submit", style: TextStyle(fontSize: 25)),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _showAlertDialog();
          },
        )
      ]),
    );
  }

  void _showAlertDialog() {
    String activity;
    String desc;
    String amt;

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        activity = _Activity.text;
        desc = _Desc.text;
        amt = _Amount.text;
        addEntity(activity, desc, int.parse(amt));
        postActivity();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Please Enter Name and Description"),
      content: IntrinsicHeight(
        child: Column(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _Activity,
                decoration: new InputDecoration(
                    hintText: "Acticity Name",
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: _Desc,
                decoration: new InputDecoration(
                    hintText: "Activity Description",
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: _Amount,
                decoration: new InputDecoration(
                    hintText: "Amount Consumed  Per Use",
                    contentPadding: EdgeInsets.all(10)),
              ),
            )
          ],
        ),
      ),
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

  void addEntity(String actName, String desc, int amount) {
    setState(() {
      entityList.add(Entity(actName, desc, amount));
    });
  }

  void postEntry() async {
    var totalWater = 0;
    // Loop through the entry lsit that Saqib made and get all the amounts, add them tofether for a total amount, then return that.\
    for (int i = 0; i < entityList.length; i++) {
      totalWater = totalWater + entityList[i].waterUnits;
    }
    print("Total Units: " + totalWater.toString());

    var uri = Uri.parse('http://10.11.25.60:443/api/entries');

    Map<String, dynamic> map = {
      "activity_id": "NULL",
      "preset_id": 1,
      "username": "Maaloufer",
      "day": currentDate,
      "amount": totalWater
    };
    String rawJson = jsonEncode(map);

    http.Response response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: rawJson,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  void postActivity() async {
    print("Activity Posted");
    var uri = Uri.parse('http://10.11.25.60:443/api/activities');

    Map<String, dynamic> map = {
      "username": "Maaloufer",
      "name": _Activity.text, //name
      "amount": _Amount.text, // amount
      "units": _Desc.text, // Description
      "creation": currentDate,
      "update": currentDate
    };
    String rawJson = jsonEncode(map);

    http.Response response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: rawJson,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

class Entity {
  String entityName;
  String desc;
  int waterUnits;

  Entity(this.entityName, this.desc, this.waterUnits);
}

class entityData {
  String NAME;
  int AMOUNT;
  String UNIT;

  entityData({required this.NAME, required this.AMOUNT, required this.UNIT});

  factory entityData.fromJson(Map<String, dynamic> json) {
    return entityData(
        NAME: json['NAME'], AMOUNT: json['AMOUNT'], UNIT: json['UNIT']);
  }
}
// So we have posted an entry to the database

// now we must post an activity.

