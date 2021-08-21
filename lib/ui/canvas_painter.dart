import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sparkler/model/particle.dart';

class CanvasPainter extends CustomPainter {
  CanvasPainter(this.particles);

  final Iterable<Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final draw = (Particle e) => canvas.drawLine(
        Offset(centerX + e.prevPosition.x, centerY + e.prevPosition.y),
        Offset(centerX + e.position.x, centerY + e.position.y),
        Paint()
          ..color = e.color
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, e.sigma)
          ..strokeWidth = max(e.deameter, 0.001));
    particles.forEach(draw);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 0.01,
        Paint()..color = Color.fromRGBO(255, 150, 150, 0.5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
