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
      (e) {
        canvas.drawCircle(
            Offset(
              size.width / 2 + e.position.x,
              size.height / 2 + e.position.y,
            ),
            e.radius * 15,
            Paint()..color = Color.fromRGBO(255, 255, 150, e.opacity / 5)
            // ..maskFilter = MaskFilter.blur(
            //   BlurStyle.normal,
            //   e.position.z / 10,
            // ),
            );
      },
    );
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 3.5,
        Paint()..color = Color.fromRGBO(255, 150, 150, 0.9));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
