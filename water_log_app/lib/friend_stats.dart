import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:water_log_app/models/userModel.dart' as userModel;

class statsFriends extends StatelessWidget {
  // This widget is the root of your application.

  String username;

  statsFriends({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePageFriends(username: username),
    );
  }
}

class MyHomePageFriends extends StatefulWidget {

  String username;

  MyHomePageFriends({
    Key? key,
    required this.username,
  }) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageFriends> {
  late List<GDPData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  bool showPassword = false;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  Widget build(BuildContext context) {
    print(widget.username);
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend Data"),
        elevation: 1,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        // image: DecorationImage(
                        //     fit: BoxFit.cover,
                        //     image: NetworkImage(
                        //       "C:\Users\saqib\Documents\GitHub\FormalLanguagesFinal\WaterLog\water_log_app\assets\images\newuser.png",
                        //     ))
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.blue,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              TextFormField(
                readOnly: true,
                enabled: false,
                decoration:
                    const InputDecoration(labelText: 'Username: Philbrooker'),
              ),
              TextFormField(
                readOnly: true,
                enabled: false,
                decoration: const InputDecoration(
                    labelText: 'Full Name: Henry Philbrook'),
              ),
              TextFormField(
                readOnly: true,
                enabled: false,
                decoration:
                    const InputDecoration(labelText: 'Age: 21 Years Old'),
              ),
              Container(
                height: 400,
                width: 400,
                child: buildGraph(context),
              ),
              SizedBox(
                height: 35,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        enabled: false,
        readOnly: true,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            //loatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  @override
  Widget buildGraph(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SfCartesianChart(
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries>[
            BarSeries<GDPData, String>(
                isTrackVisible: false,
                opacity: 0.5,
                color: const Color.fromRGBO(51, 153, 255, 255),
                name: 'Water Usage',
                dataSource: _chartData,
                pointColorMapper: (GDPData sales, _) => sales.segmentColor,
                xValueMapper: (GDPData gdp, _) => gdp.continent,
                yValueMapper: (GDPData gdp, _) => gdp.gdp,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                dataLabelSettings: DataLabelSettings(isVisible: true),
                width: 0.8, // Width of the bars
                spacing: 0.2, // Spacing between the bars
                enableTooltip: true)
          ],
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              //numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)
              title: AxisTitle(text: 'Gallons Per Day - (09/27/2021)'))),
    ));
  }

  List<GDPData> getChartData() {
    final List<GDPData> chartData = [
      GDPData('Sunday', 16, Colors.blue),
      GDPData('Saturday', 46, Colors.red),
      GDPData('Friday', 15, Colors.blue),
      GDPData('Thursday', 42, Colors.red),
      GDPData('Wednesday', 30, Colors.green),
      GDPData('Tuesday', 25, Colors.green),
      GDPData('Monday', 46, Colors.red),
    ];
    return chartData;
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.segmentColor);
  final String continent;
  final double gdp;
  final Color segmentColor;
}

