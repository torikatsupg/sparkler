import 'package:flutter/material.dart';
import 'package:sparkler/spark.dart';

class SparkPainter extends CustomPainter {
  SparkPainter(this.sparks);

  final List<Spark> sparks;

  @override
  void paint(Canvas canvas, Size size) {
    sparks.forEach(
      (e) => canvas.drawCircle(
        Offset(e.x, e.y),
        10,
        Paint(),
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
