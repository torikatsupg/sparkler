import 'dart:math';

import 'package:sparkler/particle.dart';
import 'package:sparkler/spark.dart';
import 'package:vector_math/vector_math.dart';

final gravity = Vector3(0, 9.8, 0);
final p0 = Vector3(250, 400, 200);
final initMass = 0.02;

class SparkState {
  List<Spark> sparks = [];

  Iterable<Particle> particles = [];

  void init() {
    sparks = [
      _createSpark(),
      _createSpark(),
      _createSpark(),
      _createSpark(),
      _createSpark(),
      _createSpark(),
      _createSpark(),
      _createSpark(),
      _createSpark(),
    ];
  }

  Spark _createSpark() {
    final random = Random();
    return Spark(
      acceraration: gravity,
      velocity: Vector3(
        random.nextInt(100).toDouble() * (random.nextBool() ? -1 : 1),
        random.nextInt(100).toDouble() * (random.nextBool() ? -1 : 1),
        random.nextInt(100).toDouble() * (random.nextBool() ? -1 : 1),
      ),
      position: p0,
      mass: initMass,
    );
  }

  void update() {
    print('update');
    sparks = [
      ...sparks.map((e) => e.advance()).expand((e) => e),
      if (Random().nextDouble() > 0.85) _createSpark(),
    ];
    particles = sparks.map((e) => Particle(e.position, e.radius));
  }
}
