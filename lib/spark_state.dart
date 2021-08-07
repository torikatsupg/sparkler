import 'package:sparkler/particle.dart';
import 'package:sparkler/spark.dart';
import 'package:sparkler/wind.dart';

class SparkState {
  List<Spark> sparks = [];

  Iterable<Particle> particles = [];

  Wind wind = Wind.init();

  void init() {
    sparks = [
      Spark.create(),
      Spark.create(),
    ];
  }

  void update() {
    sparks = [
      ...sparks.map((e) => e.advance(wind.velocity)).expand((e) => e),
      if (random.nextDouble() > 0.6) Spark.create(),
    ];
    particles =
        sparks.map((e) => e.toParticles(wind.velocity)).expand((e) => e);
    wind = wind.update();
  }
}
