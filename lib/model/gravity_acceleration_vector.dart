import 'dart:math';

import 'package:vector_math/vector_math.dart';

// 座標計算
final g = Vector3(0, 9.8, 0);

Vector3 at(Vector3 v0, double m, double t, Vector3 vw) {
  final k = pow(m, 2 / 3);
  final mDivK = m / k;

  return ((v0 - vw) - (g * mDivK)) * -mDivK * (exp(mDivK * t) - 1) +
      (vw + g * mDivK) * t;
}
