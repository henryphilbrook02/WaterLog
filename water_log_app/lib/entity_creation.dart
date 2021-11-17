import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:water_log_app/custom_theme.dart';
import 'package:http/http.dart' as http;

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
  @override
  _EntityCreationPageState createState() => _EntityCreationPageState();
}

class _EntityCreationPageState extends State<EntityCreationItem> {
  Future<entityData> postRequest() async {
    final response =
        await http.get(Uri.parse('http://10.11.25.60:443/api/activities'));
    if (response.statusCode == 200) {
      for (var i = 0; i < 3; i++) {
        var mainUser = entityData.fromJson(jsonDecode(response.body)[i]);
        var activityName = mainUser.NAME.toString();
        var activityUnit = mainUser.UNIT.toString();

        addEntity(activityName, activityUnit);
        //print(activityName);
        // day = mainUser.wDay.toString();
        // DateTime dt = DateTime.parse(day);
        // myDay = DateFormat('EEEE').format(dt);
        // average = average + sum;
        // print("Average: " + average.toString());
        // mySums.add(sum);
        // myDays.add(myDay);
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

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        activity = _Activity.text;
        desc = _Desc.text;
        addEntity(activity, desc);
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

  void addEntity(String actName, String desc) {
    setState(() {
      entityList.add(Entity(actName, desc, 0));
    });
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
