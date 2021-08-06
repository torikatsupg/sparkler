import 'dart:math';

import 'package:sparkler/spark_state.dart';
import 'package:vector_math/vector_math.dart';

const milliSecPerFrame = 0.116;

class Spark {
  Spark({
    required this.acceraration,
    required this.velocity,
    required this.position,
    this.duration = 0,
    required this.mass,
  });
  final Vector3 acceraration;
  final Vector3 velocity;
  final Vector3 position;
  final double duration;
  final double mass;

  // 線香花火の燃焼時間は40sほど
  // 線香花火の質量を0.5gとし、一定の速度で燃焼するとした時、
  // 0.5g : 40s = mass g : lifetime
  // より、
  // lifetime = mass * 80
  late final double lifetime = mass * 80;

  // 火花の直径
  // 質量に比例する
  // 硝酸カリウムの密度は2.11g/cm^3
  // 火花の体積=質量/2.11になる
  // 火花は球体である
  // 球体の体積は V = 3/4πr^3より、r=
  late final double radius = pow(mass / 2.11 * 4 / 3 * pi, 1 / 3).toDouble();

  List<Spark> advance() {
    if (mass < 0.0001) {
      return [];
    }

    final nextDuration = duration + milliSecPerFrame;
    if (nextDuration < lifetime) {
      return [
        Spark(
          acceraration: gravity,
          velocity: _calcVelocity(velocity, acceraration, milliSecPerFrame),
          position:
              _calcPosition(position, velocity, acceraration, milliSecPerFrame),
          duration: nextDuration,
          mass: mass,
        ),
      ];
    }

    final random = Random();
    final weight = random.nextDouble();
    final nextPosition =
        _calcPosition(position, velocity, acceraration, milliSecPerFrame);
    final m1 = mass * weight;
    final maxVelocity = (mass / initMass * 100).toInt();
    if (maxVelocity <= 0) {
      return [];
    }
    final v1 = Vector3(
      random.nextInt(maxVelocity).toDouble() * (random.nextBool() ? -1 : 1),
      random.nextInt(maxVelocity).toDouble() * (random.nextBool() ? -1 : 1),
      random.nextInt(maxVelocity).toDouble() * (random.nextBool() ? -1 : 1),
    );
    return [
      Spark(
        acceraration: gravity,
        velocity: v1,
        position: nextPosition,
        mass: m1,
      ),
      Spark(
        acceraration: gravity,
        velocity: velocity - v1,
        position: nextPosition,
        mass: mass - m1,
      ),
    ];
  }

  // 速度を算出する
  Vector3 _calcVelocity(Vector3 v0, Vector3 a, double t) => Vector3(
        _calcVelocityOneDimentional(v0.x, a.x, t),
        _calcVelocityOneDimentional(v0.y, a.y, t),
        _calcVelocityOneDimentional(v0.z, a.z, t),
      );

  // 距離を算出する
  Vector3 _calcPosition(Vector3 p0, Vector3 v0, Vector3 a, double t) => Vector3(
        _calcPositionOneDimentional(p0.x, v0.x, t, a.x),
        _calcPositionOneDimentional(p0.y, v0.y, t, a.y),
        _calcPositionOneDimentional(p0.z, v0.z, t, a.z),
      );

  // t秒後の速度を算出する
  // 以下で求めることができる
  // v0: 初速度
  // a: 加速度
  // t: 時間
  // v = v0*+at
  double _calcVelocityOneDimentional(double v0, double a, double t) =>
      v0 + a * t;

  // t秒間に移動する距離を算出する
  // 移動する距離は以下で求めることができる
  // v0: 初速度
  // p0: 初期位置
  // t: 時間
  // a: 加速度
  // p = p0 + v0t + 1/2at^2
  double _calcPositionOneDimentional(
          double p0, double v0, double t, double a) =>
      p0 + v0 * t + 0.5 * a * t * t;
}
