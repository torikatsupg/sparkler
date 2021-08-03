import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sparkler/model/gravity_acceleration_vector.dart';
import 'package:vector_math/vector_math.dart' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sparkler',
      home: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: p.y,
              left: p.x,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: ap.y,
              left: ap.x,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 10), (_) => onTick());
  }

  late final Timer timer;
  double t = 0;
  math.Vector3 p = math.Vector3(50, 0, 0);
  math.Vector3 v0 = math.Vector3(0, 0, 0);
  math.Vector3 vw = math.Vector3(0, 0, 0);

  math.Vector3 ap = math.Vector3(100, 0, 0);
  math.Vector3 av0 = math.Vector3(3.2, 0, 0);
  math.Vector3 avw = math.Vector3(30, 1, 0);

  void onTick() {
    setState(() {
      // v = velocity(v0, t, a);
      // p = position(v0, t, a);
      p += at(v0, 1, t, vw);
      ap += at(av0, 1, t, t != 0.5 ? avw : math.Vector3.all(0));

      t += 0.005;
    });
  }
}
