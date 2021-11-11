// import 'package:flutter/material.dart';
// import 'package:water_log_app/custom_theme.dart';

// class EntityCreation extends StatelessWidget {
//     @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: theme_class.light_theme,
//       home: EntityCreation(),
//     );
//   }
// }

// class EntityCreationItem extends StatefulWidget {
//   @override
//   _EntityCreationPageState createState() => _EntityCreationPageState();
// }

// class _EntityCreationPageState extends State<EntityCreationItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Your Water Intake"),
//         elevation: 1,
//       ),
//       body: ListView(
//         children: [
//           buildEntity("Shower", 5)
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () => addEntity(),
//       ),
//     );
//   }
// }

// Widget buildEntity (String entityName, int waterUnits) {
//   int waterUnits = 0;
//   return ListTile(
//     leading: Icon(Icons.water),
//     title: Text(entityName),
//     subtitle: Text("Enter the amount of gallons used for this task."),
//     trailing: FittedBox(
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () => incrementWater(waterUnits),
//             /*
//               Not sure how to fix this, not sure what state I need to change here
//               I know this has to decrement the quantity of water used.
//             */
//             icon: Icon(Icons.remove)
//             ),
//           Text(waterUnits.toString()),
//           IconButton(
//             onPressed: () => incrementWater(waterUnits),
//             //onPressed: () { setState( () {waterUnits!=0 ? waterUnits--: waterUnits;} ); },
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

// Widget addEntity() {
//   return Card(

//   );
// }

// Widget incrementWater(int waterUnits) {
//   return
//   int waterUnits++;
// }