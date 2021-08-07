import 'package:sparkler/particle.dart';
import 'package:sparkler/spark.dart';

class SparkState {
  List<Spark> sparks = [];

  Iterable<Particle> particles = [];

  void init() {
    sparks = [
      Spark.create(),
      Spark.create(),
    ];
  }

  void update() {
    sparks = [
      ...sparks.map((e) => e.advance()).expand((e) => e),
      if (random.nextDouble() > 0.8) Spark.create(),
    ];
    particles = sparks.map((e) => e.createParticles()).expand((e) => e);
  }
}
