import 'package:flutter/material.dart';
import 'package:water_log_app/custom_theme.dart';

class EntityCreation extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme_class.light_theme,
      home: EntityCreationPage(),
    );
  }
}

class EntityCreationPage extends StatefulWidget {
  @override
  _EntityCreationPageState createState() => _EntityCreationPageState();
}

class _EntityCreationPageState extends State<EntityCreationPage> {
  @override
  Widget build(BuildContext context) {
  return Center(
    child: Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.water),
            title: Text('20 Minute Shower'),
            subtitle: Text('40 Gallons'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Icon(Icons.exposure_minus_1_rounded),
                onPressed: () { 
                  /* 
                  This is where the data should be sent to the database
                   */ 
                  },
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Icon(Icons.plus_one_rounded),
                onPressed: () { 
                  /* 
                  This is where the data should be sent to the database
                 */ },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    ),
  );
}
}