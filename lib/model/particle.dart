import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sparkler/model/vector.dart';

class Particle {
  Particle({
    required this.position,
    required this.prevPosition,
    required this.deameter,
    required this.lifetime,
    required this.elapsedTime,
  });
  final Vector position;
  final Vector prevPosition;
  final double deameter;
  final double lifetime;
  final double elapsedTime;

  late final Color color = () {
    final a = elapsedTime / lifetime;
    final opacity = max(a, 0.15);
    return Color.fromRGBO(255, 95, 45, opacity);
  }();
}
