import 'dart:math';

import 'package:sparkler/particle.dart';
import 'package:vector_math/vector_math.dart';

const milliSecPerFrame = 0.116;
const particleCount = 11;
const radiusCoefficient = (1 / 2.11) * 4 / (3 * pi);
const div3 = 1 / 3;
final random = Random();
final gravity = Vector3(0, -9.8, 0);
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
      velocity: Vector3(
        _calcInitOneDementionalVelocity(),
        _calcInitOneDementionalVelocity(),
        _calcInitOneDementionalVelocity(),
      ),
      position: Vector3.all(0),
      mass: initMass,
      initMass: initMass,
    );
  }

  final Vector3 acceraration;
  final Vector3 velocity;
  final Vector3 position;
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

  // 火花の動きを進める
  Iterable<Spark> advance() {
    if (mass < 0.0001) {
      return [];
    }

    final nextDuration = duration + milliSecPerFrame;
    if (nextDuration < lifetime) {
      return [
        Spark(
          acceraration: gravity,
          velocity: _calcVelocity(velocity, acceraration, milliSecPerFrame),
          position: _calcPositionWithAirResistance(
              position, mass, velocity, milliSecPerFrame, acceraration),
          duration: nextDuration,
          mass: mass,
          initMass: initMass,
        ),
      ];
    }

    final weight = random.nextDouble();
    final nextPosition = _calcPositionWithAirResistance(
        position, mass, velocity, milliSecPerFrame, acceraration);
    final m1 = mass * weight;
    final m2 = mass - m1;
    final maxVelocity = initVelocity * mass ~/ initMass; // ~/で少数を丸められる
    final v1 = Vector3(
      random.nextInt(maxVelocity).toDouble() * (random.nextBool() ? -1 : 1),
      random.nextInt(maxVelocity).toDouble() * (random.nextBool() ? -1 : 1),
      random.nextInt(maxVelocity).toDouble() * (random.nextBool() ? -1 : 1),
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
  // TODO(torikatsu): 要調整
  Iterable<Particle> createParticles() => forParticls.map(
        (e) => Particle(
          _calcPositionWithAirResistance(
              position, mass, velocity, e, acceraration),
          radius,
          1 - e,
        ),
      );

  // 速度を算出する
  Vector3 _calcVelocity(Vector3 v0, Vector3 a, double t) => Vector3(
        velocity.x,
        _calcVelocityOneDimentional(v0.y, a.y, t),
        velocity.y,
      );

  // t秒後の速度を計算する
  // v = v0*+at
  double _calcVelocityOneDimentional(double v0, double a, double t) =>
      v0 + a * t;

  // 空気抵抗込みの移動量
  // Δ→r(t) = 1/b→v0(1-e^-bt) - 1/b^2→g{bt - (1 - e^-bt)}
  Vector3 _calcPositionWithAirResistance(
      Vector3 p0, double mass, Vector3 v0, double t, Vector3 a) {
    final k = pow(mass, 2 / 3) as double;
    final powE = 1 - pow(e, -k * t) as double;
    return p0 + v0 * powE * 1 / k - a * (k * t - powE) / (k * k);
  }
}
