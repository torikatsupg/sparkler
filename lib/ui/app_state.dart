import 'package:sparkler/model/particle.dart';
import 'package:sparkler/model/spark.dart';
import 'package:sparkler/model/wind.dart';

class AppState {
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
      if (random.nextDouble() > 0.9) Spark.create(),
    ];
    particles =
        sparks.map((e) => e.toParticles(wind.velocity)).expand((e) => e);
    wind = wind.update();
  }
}
