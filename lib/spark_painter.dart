import 'package:flutter/material.dart';
import 'package:sparkler/particle.dart';

class SparkPainter extends CustomPainter {
  SparkPainter(this.particles);

  final Iterable<Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.black);
    particles.forEach(
      (e) => canvas.drawCircle(Offset(e.position.x, e.position.y), e.radius * 5,
          Paint()..color = Color.fromRGBO(195, 95, 55, e.opacity)
          // ..maskFilter = MaskFilter.blur(
          //   BlurStyle.normal,
          //   e.position.z / 10,
          // ),
          ),
    );
    // canvas.drawColor(Colors.black, BlendMode.clear);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
