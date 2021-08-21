import 'package:flutter/material.dart';
import 'package:sparkler/model/vector.dart';

class Particle {
  Particle({
    required this.position,
    required this.prevPosition,
    required this.deameter,
  });
  final Vector position;
  final Vector prevPosition;
  final double deameter;

  late final Color color = Color.fromRGBO(255, 255, 255, 1);

  late final double sigma = () {
    final z = position.z.abs();
    if (z < 0.035) return 0.00005;
    if (z < 0.040) return 0.0003;
    if (z < 0.045) return 0.0005;
    if (z < 0.050) return 0.0008;
    if (z < 0.055) return 0.001;
    return 0.002;
  }();
}
