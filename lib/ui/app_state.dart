import 'dart:async';

import 'package:sparkler/model/particle.dart';
import 'package:sparkler/model/spark.dart';
import 'package:sparkler/model/wind.dart';

const _sparkGenerateWeight = 0.9;
const _milliSecondsPerFrame = 17 / 2;

class AppState {
  Iterable<Spark> sparks = [];
  List<Particle> particles = [];
  Wind wind = Wind.init();

  void init() => Timer.periodic(Duration(microseconds: 500), _update);

  void _update(Timer timestamp) {
    // カウンターが1F進んだらリセットする
    if (timestamp.tick % _milliSecondsPerFrame == 0) {
      particles.clear();
    }
    // 火花の更新
    sparks = [
      ...sparks.map((e) => e.advance(wind.velocity)).expand((e) => e),
      if (random.nextDouble() > _sparkGenerateWeight) Spark.init(wind.velocity),
    ];
    // 火花をもとにパーティクルの更新
    particles.addAll(sparks.map((e) => e.toParticle()));
    // 風の更新
    // wind = wind.update();
  }
}
