import 'package:flutter/material.dart';
import 'package:sparkler/ui/canvas_painter.dart';
import 'package:sparkler/ui/app_state.dart';

class Canvas extends StatefulWidget {
  const Canvas({Key? key}) : super(key: key);

  CanvasState createState() => CanvasState();
}

class CanvasState extends State<Canvas> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  final state = AppState();

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1),
    )..forward();
    super.initState();
    state.init();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 400,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) => CustomPaint(
          painter: CanvasPainter(state.particles),
          size: Size(double.infinity, double.infinity),
          isComplex: true,
          willChange: true,
        ),
      ),
    );
  }
}
