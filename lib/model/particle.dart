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

  late final Color color =
      Color.fromRGBO(255, 95, 45, 0.6);
}
