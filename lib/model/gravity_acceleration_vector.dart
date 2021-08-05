import 'package:vector_math/vector_math.dart';

// 速度を算出する
Vector3 calculateVelocity(Vector3 v0, Vector3 a, double t) {
  return Vector3(
    calculateVelocityOneDimentional(v0.x, a.x, t),
    calculateVelocityOneDimentional(v0.y, a.y, t),
    calculateVelocityOneDimentional(v0.z, a.z, t),
  );
}

// 距離を算出する
Vector3 calculatePosition(Vector3 p0, Vector3 v0, Vector3 a, double t) {
  return Vector3(
    calculatePositionOneDimentional(p0.x, v0.x, t, a.x),
    calculatePositionOneDimentional(p0.y, v0.y, t, a.y),
    calculatePositionOneDimentional(p0.z, v0.z, t, a.z),
  );
}

// t秒後の速度を算出する
// 以下で求めることができる
// v0: 初速度
// a: 加速度
// t: 時間
// v = v0*+at
double calculateVelocityOneDimentional(double v0, double a, double t) {
  return v0 + a * t;
}

// t秒間に移動する距離を算出する
// 移動する距離は以下で求めることができる
// v0: 初速度
// p0: 初期位置
// t: 時間
// a: 加速度
// p = p0 + v0t + 1/2at^2
double calculatePositionOneDimentional(double p0, double v0, double t, double a) {
  return p0 + v0 * t + 0.5 * a * t * t;
}
