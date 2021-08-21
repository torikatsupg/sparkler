import 'dart:async';
import 'dart:isolate';

import 'package:sparkler/model/particle.dart';
import 'package:sparkler/model/spark.dart';
import 'package:sparkler/model/wind.dart';

const _sparkGenerateWeight = 0.95;
const _milliSecondsPerFrame = 16;
const _x = 3;
const _y = _milliSecondsPerFrame ~/ _x;

class _ParticleGenerator {
  _ParticleGenerator(this.port);
  SendPort port;
  Iterable<Spark> sparks = [];
  List<Particle> particles = [];
  Wind wind = Wind.init();

  void init() => Timer.periodic(Duration(milliseconds: _x), _update);

  void _update(Timer timestamp) {
    // カウンターが1F進んだらリセットする
    if (timestamp.tick % _y == 0) {
      port.send(particles);
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
    wind = wind.update();
  }
}

class AppState {
  List<Particle> _particles = [];

  List<Particle> get particles => _particles;

  final _receivePort = ReceivePort();

  late final SendPort sendPort = _receivePort.sendPort;

  bool hasListen = false;

  // パーティクルの生成処理は重いので生成は別スレッドで行い、定期的に生成結果をメインスレッドで受け取る
  void init() {
    if (hasListen) return;
    _receivePort.listen((message) {
      if (message is List<Particle>) {
        _particles.clear();
        _particles = message;
      }
    });
    hasListen = true;
  }
}

void _init(dynamic initialMessage) {
  if (initialMessage is SendPort) _ParticleGenerator(initialMessage)..init();
}

void invokeIsolate(SendPort initialMessage) {
  Isolate.spawn(_init, initialMessage);
}
