import 'package:vector_math/vector_math.dart';

class Particle {
  const Particle(this.position, this.radius, this.opacity);
  final Vector3 position;
  final double radius;
  final double opacity;
}
