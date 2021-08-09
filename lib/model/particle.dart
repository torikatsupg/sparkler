import 'package:flutter/material.dart';
import 'package:sparkler/model/vector.dart';

class Particle {
  const Particle(this.position, this.deameter);
  final Vector position;
  final double deameter;

  static const color = Color.fromRGBO(255, 95, 45, 0.9);
}
