import 'package:sparkler/particle.dart';
import 'package:sparkler/spark.dart';
import 'package:vector_math/vector_math.dart';

final gravity = Vector3(0, 9.8, 0);
final p0 = Vector3(250, 400, 200);
final initMass = 0.02;
final initVelocity = 60;

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
        random.nextInt((1 + random.nextInt(initVelocity))).toDouble() *
            (random.nextBool() ? -1 : 1),
        random.nextInt((1 + random.nextInt(initVelocity))).toDouble() *
            (random.nextBool() ? -1 : 1),
        random.nextInt((1 + random.nextInt(initVelocity))).toDouble() *
            (random.nextBool() ? -1 : 1),
      ),
      position: p0,
      mass: initMass,
    );
  }

  void update() {
    sparks = [
      ...sparks.map((e) => e.advance()).expand((e) => e),
      if (random.nextDouble() > 0.93) _createSpark(),
    ];
    particles = sparks.map((e) => e.createParticles()).expand((e) => e);
  }
}
