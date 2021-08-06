import 'package:flutter/material.dart';
import 'package:sparkler/spark_painter.dart';
import 'package:sparkler/spark_state.dart';

class Canvas extends StatefulWidget {
  const Canvas({Key? key}) : super(key: key);

  CanvasState createState() => CanvasState();
}

class CanvasState extends State<Canvas> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  final state = SparkState();

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1),
    )
      ..addListener(state.update)
      ..forward();
    super.initState();
    state.init();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => CustomPaint(
        painter: SparkPainter(state.particles),
        size: Size(double.infinity, double.infinity),
      ),
    );
  }
}
