import 'package:flutter/material.dart';
import 'package:sparkler/particle.dart';

class SparkPainter extends CustomPainter {
  SparkPainter(this.particles);

  final Iterable<Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    particles.forEach(
      (e) => canvas.drawCircle(
        Offset(e.position.x, e.position.y),
        e.radius * 5,
        Paint(),
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
