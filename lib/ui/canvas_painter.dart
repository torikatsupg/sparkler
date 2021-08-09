import 'package:flutter/material.dart';
import 'package:sparkler/model/particle.dart';

class CanvasPainter extends CustomPainter {
  CanvasPainter(this.particles);

  final Iterable<Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.black);
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final draw = (Particle e) => canvas.drawCircle(
        Offset(centerX + e.position.x, centerY + e.position.y),
        e.deameter,
        Paint()..color = Particle.color);
    particles.forEach(draw);
    // canvas.drawCircle(Offset(size.width / 2, size.height / 2), 1,
    //     Paint()..color = Color.fromRGBO(255, 150, 150, 0.9));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
