import 'package:vector_math/vector_math.dart';

const milliSecPerFrame = 0.116;

class Spark {
  Spark({
    required this.acceraration,
    required this.velocity,
    required this.position,
  });
  final Vector3 acceraration;
  final Vector3 velocity;
  final Vector3 position;

  // 線香花火の燃焼時間は40sほど
  // 線香花火の質量を0.5gとし、一定の速度で燃焼するとした時、
  // 0.5g : 40s = mass g : lifetime
  // より、
  // lifetime = mass * 80
  // late final double lifetime = mass * 80;

  List<Spark> advance() {
    print('advance');
    return [
      Spark(
        acceraration: Vector3(0, 9.8, 0),
        velocity: _calculateVelocity(velocity, acceraration, milliSecPerFrame),
        position: _calculatePosition(
            position, velocity, acceraration, milliSecPerFrame),
      ),
    ];
  }

  // 速度を算出する
  Vector3 _calculateVelocity(Vector3 v0, Vector3 a, double t) => Vector3(
        _calculateVelocityOneDimentional(v0.x, a.x, t),
        _calculateVelocityOneDimentional(v0.y, a.y, t),
        _calculateVelocityOneDimentional(v0.z, a.z, t),
      );

  // 距離を算出する
  Vector3 _calculatePosition(Vector3 p0, Vector3 v0, Vector3 a, double t) =>
      Vector3(
        _calculatePositionOneDimentional(p0.x, v0.x, t, a.x),
        _calculatePositionOneDimentional(p0.y, v0.y, t, a.y),
        _calculatePositionOneDimentional(p0.z, v0.z, t, a.z),
      );

  // t秒後の速度を算出する
  // 以下で求めることができる
  // v0: 初速度
  // a: 加速度
  // t: 時間
  // v = v0*+at
  double _calculateVelocityOneDimentional(double v0, double a, double t) =>
      v0 + a * t;

  // t秒間に移動する距離を算出する
  // 移動する距離は以下で求めることができる
  // v0: 初速度
  // p0: 初期位置
  // t: 時間
  // a: 加速度
  // p = p0 + v0t + 1/2at^2
  double _calculatePositionOneDimentional(
          double p0, double v0, double t, double a) =>
      p0 + v0 * t + 0.5 * a * t * t;
}
