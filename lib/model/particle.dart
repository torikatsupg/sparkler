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

  late final Color color =
      Color.fromRGBO(255, 95, 45, max(elapsedTime / lifetime, 0.15));
}
