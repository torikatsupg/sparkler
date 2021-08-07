import 'package:sparkler/particle.dart';
import 'package:sparkler/spark.dart';
import 'package:vector_math/vector_math.dart';

final gravity = Vector3(0, 9.8, 0);
final p0 = Vector3(100, 400, 200);
final initMass = 0.015;
final initMinVelocity = 25;
final initVelocity = 15;

class SparkState {
  List<Spark> sparks = [];

  Iterable<Particle> particles = [];

  void init() {
    sparks = [
      _createSpark(),
      _createSpark(),
    ];
  }

  Spark _createSpark() {
    return Spark(
      acceraration: gravity,
      velocity: Vector3(
        _calcInitOneDementionalVelocity(),
        _calcInitOneDementionalVelocity(),
        _calcInitOneDementionalVelocity(),
      ),
      position: Vector3.all(0),
      mass: initMass,
    );
  }

  double _calcInitOneDementionalVelocity() =>
      (initMinVelocity +
          random.nextInt((1 + random.nextInt(initVelocity))).toDouble()) *
      (random.nextBool() ? -1 : 1);

  void update() {
    sparks = [
      ...sparks.map((e) => e.advance()).expand((e) => e),
      if (random.nextDouble() > 0.93) _createSpark(),
    ];
    particles = sparks.map((e) => e.createParticles()).expand((e) => e);
  }
}
