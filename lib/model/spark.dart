import 'dart:math';

import 'package:sparkler/util/random.dart';
import 'package:sparkler/model/vector.dart';

// 重力加速度(kg/s^2)
final _gravity = Vector(0, 9.8, 0);

// ランダム
final random = MyRandom();

class Spark {
// カリウム化合物の密度は10^3 kg/m^3
  static final _potassiumDensity = pow(10, 3);
// 火球の表面張力は10^-1 N/m
  static final _surfaceTensionOfFireball = pow(10, -1);
// 火球の半径は R0 = (σ*s/ρ*g)^1/3 = 10^-3 m
  static final _radiusOfFireball = pow(10, -3);
// カリウム化合物の熱拡散率はk=10^-1 m^2/s
  static final _thermalDiffusivity = pow(10, -1);
// 分裂時の液滴の半径の係数
  static final _divisionCoefficient = 0.5;
// 分裂カウンタ 分裂回数は1~8回分裂した後のやつを計算するので、分裂前の値でカウンタをつくる
  static final divisionCounter = [0, 1, 2, 3, 4, 5, 6, 7];
// 分裂回数ごとの液滴の半径を求める式
  static double _calcRadius(int n) =>
      pow(_divisionCoefficient, n) * _radiusOfFireball as double;
// 分裂回数ごとの寿命を求める式
  static double _calcLifitime(int n) =>
      pow(_radiusOfFireball, 2) /
      _thermalDiffusivity *
      pow(_divisionCoefficient, 2 * n);
// 分裂回数ごとの液滴の初速を求める式
  static double _calcInitialVelocity(int n) =>
      sqrt(
          _surfaceTensionOfFireball / (_potassiumDensity * _radiusOfFireball)) *
      pow(_divisionCoefficient, -(n - 1) / 2);

// 分裂回数ごとの液滴の半径
  static final _radius = divisionCounter.map(_calcRadius);
// 分裂回数ごとの液滴の寿命
  static final _lifetime = divisionCounter.map(_calcLifitime);
// 分裂回数ごとの液滴の初速
  static final _initialVelocity = divisionCounter.map(_calcInitialVelocity);
}
