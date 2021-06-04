import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';

import 'Timer Page/countdountimerpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSwitchOn = false;

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay picked_s = (await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        }));

    if (picked_s != null &&
        picked_s != selectedTime &&
        selectedTime.hour >= DateTime.now().hour) {
      setState(() {
        selectedTime = picked_s;
      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text('Error'),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok'),
                )
              ],
            );
          });
    }
  }

  String _timeString;
  String _counttimer;
  TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.now());
  @override
  void initState() {
    _timeString =
        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    _counttimer = "${selectedTime.hour} : ${selectedTime.minute}";
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

  void _getCurrentTime() {
    setState(() {
      _timeString = DateFormat('hh:mm:ss').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text(
              'Current time: ',
              style: TextStyle(
                  fontFamily: 'Kameron', fontSize: 20, color: Colors.green),
            ),
          ),
          Text(
            '${_timeString}',
            style: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 70,
                backgroundColor: Colors.green),
          ),
          Text(
            'Selected Time:',
            style: TextStyle(fontFamily: 'Kameron', fontSize: 20),
          ),
          Text(
            '${selectedTime.hour} : ${selectedTime.minute}',
            style: TextStyle(
                fontSize: 60,
                backgroundColor: Colors.black,
                color: Colors.white),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, right: 24, bottom: 8, top: 10),
            child: Container(
              height: 48,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.brown,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: MaterialButton(
                color: Colors.black87,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  highlightColor: Colors.black87,
                  onTap: () {
                    // Navigator.pushAndRemoveUntil(context, Routes.SPLASH, (Route<dynamic> route) => false);
                    _selectTime(context);
                    // Navigator.pushReplacementNamed(context, Routes.TabScreen);
                  },
                  child: Center(
                    child: Text(
                      "Select Time",
                      style: TextStyle(
                          fontFamily: 'Kameron',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          FlutterSwitch(
            value: isSwitchOn,
            onToggle: (value) {
              setState(() {
                isSwitchOn = value;

                print(value);
              });
            },
          ),
          Text(
            'Note:',
            style: TextStyle(fontFamily: 'Kameron', fontSize: 20),
          ),
          Text(
            "User must select time before pressing submit",
            style: TextStyle(
                fontFamily: 'Kameron', fontSize: 15, color: Colors.red),
          ),
          Text(
            'Selected time must be future',
            style: TextStyle(
                fontFamily: 'Kameron', fontSize: 15, color: Colors.red),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 270, right: 24, bottom: 8, top: 50),
            child: Container(
              height: 48,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.brown,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: MaterialButton(
                color: Colors.black87,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  highlightColor: Colors.black87,
                  onTap: () {
                    if (isSwitchOn == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CountdownTimerPage(
                                  selectedTime.hour,
                                  selectedTime.minute + 20 % 60)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CountdownTimerPage(
                                  selectedTime.hour, selectedTime.minute)));
                    }
                  },
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          fontFamily: 'Kameron',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return page;
        }));
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        color: Colors.blue,
        width: double.infinity,
        alignment: Alignment.center,
        height: 100,
        child: Text(
          title,
          style: TextStyle(fontSize: 36),
        ),
      ),
    );
  }
}
