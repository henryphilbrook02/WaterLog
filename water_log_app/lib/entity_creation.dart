 import 'package:flutter/material.dart';
 import 'package:water_log_app/custom_theme.dart';

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

    List<Entity> entityList = [
    Entity("Shower", "Morning Shower", 5),
    Entity("Shower", "Evening Shower", 5),
    Entity("Flush", "null", 4),
  ];

  late TextEditingController _Activity;
  late TextEditingController _Desc;
  initState()
  {
    _Activity = new TextEditingController();
    _Desc = new TextEditingController();
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
                trailing: 
                FittedBox(
                  child: Row(
                    children: [
                      IconButton(
                        color: Colors.black,
                        highlightColor: Colors.red.shade100,
                        splashRadius: 15,
                        onPressed: () { setState( () {entityList[index].waterUnits!=0 ? entityList[index].waterUnits--: entityList[index].waterUnits;} ); },
                        /*
                          Not sure how to fix this, not sure what state I need to change here
                          I know this has to decrement the quantity of water used.
                        */
                        icon: Icon(Icons.remove)
                        ),
                      Text(entityList[index].waterUnits.toString()),
                      IconButton(
                        color: Colors.black,
                        highlightColor: Colors.green.shade100,
                        splashRadius: 15,
                        onPressed: () { setState( () {entityList[index].waterUnits!=0 ? entityList[index].waterUnits++: entityList[index].waterUnits;} ); },
                        /*
                          Not sure how to fix this, not sure what state I need to change here
                          I know this has to decrement the quantity of water used.
                        */
                        icon: Icon(Icons.add)
                        ),
                    ],
                  ),
                ),
              );
            }
          ),
          Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {}
                /*
                Here is where the page will send the list data to the database
                */,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAlertDialog();
        },
      ),
    );
  }


//   Widget buildEntity (String entityName, String desc, int waterUnits) {
//   return ListTile(
//     leading: Icon(Icons.water),
//     title: Text(entityName),
//     subtitle: Text(desc),
//     trailing: FittedBox(
//       child: Row(
//         children: [
//           IconButton(
//             color: Colors.pinkAccent,
//             highlightColor: Colors.red.shade100,
//             splashRadius: 15,
//             onPressed: () { setState( () {waterUnits!=0 ? waterUnits--: waterUnits;} ); },
//             /*
//               Not sure how to fix this, not sure what state I need to change here
//               I know this has to decrement the quantity of water used.
//             */
//             icon: Icon(Icons.remove)
//             ),
//           Text(waterUnits.toString()),
//           IconButton(
//             color: Colors.lightGreen,
//             highlightColor: Colors.green.shade100,
//             splashRadius: 15,
//             onPressed: () { setState( () {waterUnits!=0 ? waterUnits++: waterUnits;} ); },
//             /*
//               Not sure how to fix this, not sure what state I need to change here
//               I know this has to decrement the quantity of water used.
//             */
//             icon: Icon(Icons.add)
//             ),
//         ],
//       ),
//     ),
//   );
// }

  void _showAlertDialog() {
        
        String activity;
        String desc;

        // set up the button
        Widget okButton = FlatButton(
          child: Text("OK"),
          onPressed: () {Navigator.pop(context); activity = _Activity.text; desc = _Desc.text; addEntity(activity, desc);},
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
                      hintText: "Activity Name",
                      contentPadding: EdgeInsets.all(10)
                    ),
                  ),
                ),
                new Flexible(
                  child: new TextField(
                    controller: _Desc,
                    decoration: new InputDecoration(
                      hintText: "Activity Description",
                      contentPadding: EdgeInsets.all(10)
                    ),
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
      entityList.add(Entity(actName, desc, 5));
    });
  }
}

class Entity {
  String entityName;
  String desc;
  int waterUnits;

  Entity(this.entityName, this.desc, this.waterUnits);
}
