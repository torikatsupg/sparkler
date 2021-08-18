import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sparkler/ui/canvas_painter.dart';
import 'package:sparkler/ui/app_state.dart';

class Canvas extends StatefulWidget {
  const Canvas({Key? key}) : super(key: key);

  CanvasState createState() => CanvasState();
}

class CanvasState extends State<Canvas> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  final state = AppState()..init();

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1),
    )..forward();
    super.initState();
    state.init();
    invokeIsolate(state.sendPort);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            'assets/background.jpg',
            fit: BoxFit.fitHeight,
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: SizedBox.expand(
            child: ColoredBox(
              color: Color.fromRGBO(0, 0, 0, 0.8),
            ),
          ),
        ),
        Center(
          child: Transform.scale(
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
          ),
        ),
      ],
    );
  }
}
