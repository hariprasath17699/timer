import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountdownTimerPage extends StatefulWidget {
  int hour;
  int minute;
  CountdownTimerPage(this.hour, this.minute);

  @override
  _CountdownTimerPageState createState() =>
      _CountdownTimerPageState(hour, minute);
}

class _CountdownTimerPageState extends State<CountdownTimerPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  int hour;
  int minute;
  _CountdownTimerPageState(this.hour, this.minute);

  String get timerString {
    Duration duration = controller.duration * controller.value;

    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60)}';
  }

  String _timeString;
  String _counttimer;

  int _counter = 10;
  Timer _timer;
  void _getCurrentTime() {
    setState(() {
      _timeString = DateFormat('hh:mm:ss').format(DateTime.now());
    });
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  void reset() {
    setState(() {
      controller.reset();
      ;
    });
  }

  @override
  void initState() {
    super.initState();
    _timeString =
        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    _counttimer = "${selectedTime.hour} : ${selectedTime.minute}";
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    controller = AnimationController(
      vsync: this,
      duration: Duration(hours: hour, minutes: minute),
    );
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = controller.duration * controller.value;

    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black,
                    height:
                        controller.value * MediaQuery.of(context).size.height,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.yellowAccent,
                                    color: Colors.white,
                                  )),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Current time: ',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      Text(
                                        _timeString,
                                        style: TextStyle(
                                            fontSize: 40, color: Colors.teal),
                                      ),
                                      Text(
                                        'Selected time: ',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      Text(
                                        "${hour} : ${minute}",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.teal),
                                      ),
                                      Text(
                                        'Timer',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      Text(
                                        timerString,
                                        style: TextStyle(
                                          fontSize: 50.0,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 10,
                      ),
                      Text(
                        " Duration:",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                        width: 10,
                      ),
                      Text(
                        " ${duration.inHours/24.round()} hours ",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                        width: 10,
                      ),
                      Text(
                        " ${duration.inDays.round()} Days ",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                        width: 10,
                      ),
                      Text(
                        " ${duration.inMinutes.round()} Minutes ",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.teal,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 24, bottom: 100, top: 50),
                        child: Container(
                          height: 48,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 8,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: MaterialButton(
                            color: Colors.black,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                              highlightColor: Colors.black87,
                              onTap: () {
                                reset();
                              },
                              child: Center(
                                child: Text(
                                  "Reset",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return FloatingActionButton.extended(
                                backgroundColor: Colors.purpleAccent,
                                onPressed: () {
                                  if (controller.isAnimating)
                                    controller.stop();
                                  else {
                                    controller.reverse(
                                        from: controller.value == 0.0
                                            ? 1.0
                                            : controller.value);
                                  }
                                },
                                icon: Icon(controller.isAnimating
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                label: Text(
                                  controller.isAnimating ? "Pause" : "Play",
                                  style: TextStyle(color: Colors.white),
                                ));
                          }),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
