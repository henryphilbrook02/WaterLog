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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Your Water Intake"),
        elevation: 1,
      ),
      body: ListView(
        children: [
          buildEntity("Shower", "This is my daily shower",  5),
          buildEntity("Flush", "This is a flush", 2)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addEntity(),
      ),
    );
  }

  Widget buildEntity (String entityName, String desc, int waterUnits) {
  return ListTile(
    leading: Icon(Icons.water),
    title: Text(entityName),
    subtitle: Text(desc),
    trailing: FittedBox(
      child: Row(
        children: [
          IconButton(
            color: Colors.pinkAccent,
            highlightColor: Colors.red.shade100,
            splashRadius: 15,
            onPressed: () { setState( () {waterUnits!=0 ? waterUnits--: waterUnits;} ); },
            /*
              Not sure how to fix this, not sure what state I need to change here
              I know this has to decrement the quantity of water used.
            */
            icon: Icon(Icons.remove)
            ),
          Text(waterUnits.toString()),
          IconButton(
            color: Colors.lightGreen,
            highlightColor: Colors.green.shade100,
            splashRadius: 15,
            onPressed: () { setState( () {waterUnits!=0 ? waterUnits++: waterUnits;} ); },
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


}

Widget addEntity() {
  return Card(

  );
}