import 'dart:math';

import 'package:sparkler/model/particle.dart';
import 'package:sparkler/util/random.dart';
import 'package:sparkler/model/vector.dart';

const milliSecPerFrame = 0.116;
const particleCount = 11;
const radiusCoefficient = (1 / 2.11) * 4 / (3 * pi);
const div3 = 1 / 3;
final random = MyRandom();
final gravity = Vector(0, 9.8, 0);
final initVelocity = 70;
final forParticls = Iterable.generate((100).toInt(), (i) => i / 100);

class Spark {
  Spark({
    required this.acceraration,
    required this.velocity,
    required this.position,
    this.duration = 0,
    required this.mass,
    required this.initMass,
  });

  factory Spark.create() {
    double _calcInitOneDementionalVelocity() =>
        (1 + random.nextInt(initVelocity)).toDouble() *
        (random.nextBool() ? -1 : 1);
    final initMass = random.nextInt(10) / 1500;
    return Spark(
      acceraration: gravity,
      velocity: Vector(
        _calcInitOneDementionalVelocity(),
        _calcInitOneDementionalVelocity(),
        _calcInitOneDementionalVelocity(),
      ),
      position: Vector.zero(),
      mass: initMass,
      initMass: initMass,
    );
  }

  final Vector acceraration;
  final Vector velocity;
  final Vector position;
  final double duration;
  final double mass;
  final double initMass;

  // 線香花火の燃焼時間は40sほど  線香花火の質量を0.5gとし、一定の速度で燃焼するとした時、
  // 0.5g : 40s = mass g : lifetime より、 lifetime = mass * 80
  late final double lifetime = mass * 80;

  // 火花の直径
  // 硝酸カリウムの密度は2.11g/cm^3より V =m /2.11
  // 球体の体積は V = 3/4πr^3より、r= 3√{4V/(3π)}
  late final double radius = pow(mass * radiusCoefficient, div3).toDouble();

  // 火花に発生する空気抵抗の係数
  late final double k = pow(mass, 2 / 3) as double;

  // 火花の動きを進める
  Iterable<Spark> advance(Vector windowVelocity) {
    if (mass < 0.0001) {
      return [];
    }

    final nextDuration = duration + milliSecPerFrame;
    if (nextDuration < lifetime) {
      return [
        Spark(
          acceraration: gravity,
          velocity: _calcVelocity(
              velocity, windowVelocity, acceraration, milliSecPerFrame),
          position: _calcPosition(position, mass, velocity, windowVelocity,
              milliSecPerFrame, acceraration),
          duration: nextDuration,
          mass: mass,
          initMass: initMass,
        ),
      ];
    }

    final weight = random.nextDouble();
    final nextPosition = _calcPosition(position, mass, velocity, windowVelocity,
        milliSecPerFrame, acceraration);
    final m1 = mass * weight;
    final m2 = mass - m1;
    if (initMass <= 0) {
      return [];
    }
    final maxVelocity = velocity * mass / initMass; // ~/で少数を丸められる
    final v1 = Vector(
      random.nextIntAsDoubleWith(maxVelocity.x) * random.nextSign(),
      random.nextIntAsDoubleWith(maxVelocity.y) * random.nextSign(),
      random.nextIntAsDoubleWith(maxVelocity.z) * random.nextSign(),
    );
    final v2 = (velocity * mass - v1 * m1) / m2;
    return [
      Spark(
        acceraration: gravity,
        velocity: v1,
        position: nextPosition,
        mass: m1,
        initMass: initMass,
      ),
      Spark(
        acceraration: gravity,
        velocity: v2,
        position: nextPosition,
        mass: m2,
        initMass: initMass,
      ),
    ];
  }

  // パーティクルを作成する
  // パーティクルの生成間隔は1フレームに10個 ≒ 1フレームあたりのミリ秒
  Iterable<Particle> toParticles(Vector windowVelocity) =>
      forParticls.map((e) => Particle(
          _calcPosition(
            position,
            mass,
            _calcVelocity(velocity, windowVelocity, acceraration, e),
            windowVelocity,
            e,
            acceraration,
          ),
          radius,
          1 - e));

  // t秒後の速度を計算する
  Vector _calcVelocity(Vector v0, Vector vwind, Vector a, double t) =>
      (v0 + vwind) + (a - (v0 + vwind) * k) * t;

  // 空気抵抗込みの移動量
  // →r(t) = →r0 + 1/b→v0(1-e^-bt) - 1/b^2→g{bt - (1 - e^-bt)}
  Vector _calcPosition(
      Vector p0, double mass, Vector v0, Vector vwind, double t, Vector a) {
    final powE = 1 - pow(e, -k * t) as double;
    return p0 + (v0 + vwind) * powE * 1 / k - a * (k * t - powE) / (k * k);
  }
}
