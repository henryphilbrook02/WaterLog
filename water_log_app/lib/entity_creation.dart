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
    var response =
        await http.get(Uri.parse('http://10.11.25.60:443/api/presets'));
    if (response.statusCode == 200) {
      try {
        var len = jsonDecode(response.body).length;
        for (var i = 0; i < len; i++) {
          var mainUser =
              PreSetEntityData.fromJson(jsonDecode(response.body)[i]);
          var activityName = mainUser.NAME.toString();
          var activityUnit = mainUser.UNIT.toString();
          var activityAmount = mainUser.AMOUNT;
          var activityID = mainUser.ACTIVITY_ID;

          addPresetEntity(
              activityName, activityUnit, activityAmount, activityID);
        }
      } on Exception catch (exception) {
        print("Error");
        print(exception);
      } catch (error) {
        print("Error");
        print(error);
        // executed for errors of all types other than Exception
      }
    } else {
      throw Exception('Failed to load Presets');
    }

    response = await http.get(Uri.parse(
        'http://10.11.25.60:443/api/user_activities/' +
            widget.client.userName));
    if (response.statusCode == 200) {
      try {
        var len = jsonDecode(response.body).length;
        for (var i = 0; i < len; i++) {
          var mainUser = entityData.fromJson(jsonDecode(response.body)[i]);
          var activityName = mainUser.NAME.toString();
          var activityUnit = mainUser.UNIT.toString();
          var activityAmount = mainUser.AMOUNT;
          var activityID = mainUser.ACTIVITY_ID;

          addEntity(activityName, activityUnit, activityAmount, activityID);
        }
      } on Exception catch (exception) {
        print("Error");
        print(exception);
      } catch (error) {
        print("Error");
        print(error);
        // executed for errors of all types other than Exception
      }

      return entityData.fromJson(
          jsonDecode(response.body)[0]); // TODO I dont think we need this
    } else {
      throw Exception('Failed to load user');
    }
  }

  List<entry> entityList = [];

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
      body: Center(
          child: Center(
        child: Scrollbar(
          child: ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: kFloatingActionButtonMargin + 48),
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
        ),
      )),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
          height: 50,
          width: 300,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          child: FloatingActionButton.extended(
            onPressed: () async {
              await postEntry();
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
        addEntity(activity, desc, int.parse(amt),
            1); // adding 1 for ID because it will be generated
        postActivity();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Activity Entry"),
      content: IntrinsicHeight(
        child: Column(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _Activity,
                decoration: const InputDecoration(
                    hintText: "Activity Name",
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
            Flexible(
              child: TextField(
                controller: _Desc,
                decoration: const InputDecoration(
                    hintText: "Unit Of Measurement (G/GPM)",
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
            Flexible(
              child: TextField(
                controller: _Amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "Amount Consumed Each Use",
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

  void addEntity(String actName, String desc, int amount, int id) {
    setState(() {
      entityList.add(Entity(actName, amount.toString() + " " + desc, 0, id));
    });
  }

  void addPresetEntity(String actName, String desc, int amount, int id) {
    setState(() {
      entityList
          .add(PreSetEntity(actName, amount.toString() + " " + desc, 0, id));
    });
  }

  void resetList() {
    //used in post entry to reset all the amounts back to zero
    for (int i = 0; i < entityList.length; i++) {
      entityList[i].waterUnits = 0;
    }
    setState(() {
      entityList = entityList;
    });
  }

  Future<String> postEntry() async {
    var totalWater = 0;
    // Loop through the entry lsit that Saqib made and get all the amounts, add them tofether for a total amount, then return that.\
    // TODO we need to change this logic and add multiple different entrys, 1 per each activity

    var uri = Uri.parse('http://10.11.25.60:443/api/entries');

    for (int i = 0; i < entityList.length; i++) {
      //totalWater = totalWater + entityList[i].waterUnits;
      if (entityList[i].waterUnits > 0) {
        String rawJson =
            jsonEncode(entityList[i].apiBody(widget.client.userName));
        http.Response response = await http.post(
          uri,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: rawJson,
        );
      }
    }

    resetList();
    return "done";
  }

  void postActivity() async {
    var uri = Uri.parse('http://10.11.25.60:443/api/activities');

    Map<String, dynamic> map = {
      "username": widget.client.userName,
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
  }
}

abstract class entry {
  int id;
  String entityName;
  String desc;
  int waterUnits;

  entry(this.entityName, this.desc, this.waterUnits, this.id);

  apiBody(String uName) {
    Map<String, dynamic> map = {};

    return map;
  }
}

class PreSetEntity extends entry {
  int id;
  String entityName;
  String desc;
  int waterUnits;

  PreSetEntity(this.entityName, this.desc, this.waterUnits, this.id)
      : super(entityName, desc, waterUnits,
            id); //TODO this needs to be changed I think

  @override
  apiBody(String uName) {
    Map<String, dynamic> map = {
      "activity_id": null,
      "preset_id": this.id,
      "username": uName,
      "day": currentDate,
      "amount": this.waterUnits
    };

    return map;
  }
}

class PreSetEntityData {
  int ACTIVITY_ID;
  String NAME;
  int AMOUNT;
  String UNIT;

  PreSetEntityData(
      {required this.NAME,
      required this.AMOUNT,
      required this.UNIT,
      required this.ACTIVITY_ID});

  factory PreSetEntityData.fromJson(Map<String, dynamic> json) {
    return PreSetEntityData(
        NAME: json['NAME'],
        AMOUNT: json['AMOUNT'],
        UNIT: json['UNIT'],
        ACTIVITY_ID: json['ACTIVITY_ID']);
  }
}

class Entity extends entry {
  int id;
  String entityName;
  String desc;
  int waterUnits;

  Entity(this.entityName, this.desc, this.waterUnits, this.id)
      : super(entityName, desc, waterUnits, id);

  @override
  apiBody(String uName) {
    Map<String, dynamic> map = {
      "activity_id": this.id,
      "preset_id": null,
      "username": uName,
      "day": currentDate,
      "amount": this.waterUnits
    };

    return map;
  }
}

class entityData {
  int ACTIVITY_ID;
  String NAME;
  int AMOUNT;
  String UNIT;

  entityData(
      {required this.NAME,
      required this.AMOUNT,
      required this.UNIT,
      required this.ACTIVITY_ID});

  factory entityData.fromJson(Map<String, dynamic> json) {
    return entityData(
        NAME: json['NAME'],
        AMOUNT: json['AMOUNT'],
        UNIT: json['UNIT'],
        ACTIVITY_ID: json['ACTIVITY_ID']);
  }
}
// So we have posted an entry to the database

// now we must post an activity.

