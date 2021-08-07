import 'package:sparkler/model/vector.dart';

class Particle {
  const Particle(this.position, this.radius, this.opacity);
  final Vector position;
  final double radius;
  final double opacity;
}
