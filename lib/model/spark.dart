import 'dart:math';

import 'package:sparkler/util/random.dart';
import 'package:sparkler/model/vector.dart';

// ランダム
final random = MyRandom();
// 重力加速度(kg/s^2)
final _gravityAcceralation = Vector(0, 9.8, 0);
// 1ミリ秒(s)
const _1milliSeconds = 0.001;
// 1ミリ秒の二乗値のキャッシュ
final _squared1MilliSeconds = pow(_1milliSeconds, 2);

// カリウム化合物の密度は10^3 kg/m^3
final _potassiumDensity = pow(10, 3);
// 火球の表面張力は10^-1 N/m
final _surfaceTensionOfFireball = pow(10, -1);
// 火球の半径は R0 = (σ*s/ρ*g)^1/3 = 10^-3 m
final _radiusOfFireball = pow(10, -3);
// カリウム化合物の熱拡散率はk=10^-1 m^2/s
final _thermalDiffusivity = pow(10, -1);
// 分裂時の液滴の半径の係数
const _divisionCoefficient = 0.5;
// 分裂カウンタ 分裂回数は1~8回分裂した後のやつを計算するので、分裂前の値でカウンタをつくる
const _divisionCounter = [0, 1, 2, 3, 4, 5, 6, 7];
// 最大分裂回数8回
const _maxDivisionCount = 8;
// 分裂回数ごとの液滴の半径を求める式(m)
double _calcRadius(int n) =>
    pow(_divisionCoefficient, n) * _radiusOfFireball as double;
// 分裂回数ごとの寿命を求める式(s)
double _calcLifitime(int n) =>
    pow(_radiusOfFireball, 2) /
    _thermalDiffusivity *
    pow(_divisionCoefficient, 2 * n);
// 分裂回数ごとの液滴の初速を求める式(m/s)
double _calcInitialVelocity(int n) =>
    sqrt(_surfaceTensionOfFireball / (_potassiumDensity * _radiusOfFireball)) *
    pow(_divisionCoefficient, -(n - 1) / 2);
// 分裂回数ごとの液滴の初速の二乗値
double _calcSquaredInitialVelocity(int n) =>
    pow(_calcInitialVelocity(n), 2) as double;

// 分裂回数ごとの液滴の半径
final _radius = _divisionCounter.map(_calcRadius);
// 分裂回数ごとの液滴の寿命
final _lifetime = _divisionCounter.map(_calcLifitime);
// 分裂回数ごとの液滴の初速
final _squaredInitialVelocity =
    _divisionCounter.map(_calcSquaredInitialVelocity);

class Spark {
  Spark({
    required this.divisionCount,
    required this.velocity,
    required this.accerelation,
    required this.position,
    required this.elapsedTime,
  });

  // 分裂回数
  final int divisionCount;
  // 初速度
  final Vector velocity;
  // 加速度
  final Vector accerelation;
  // 位置
  final Vector position;
  // 液滴が生成されてから経過した時間(s)
  final double elapsedTime;

  // 液滴の半径(m)
  late final double radius = _radius.elementAt(divisionCount);
  // 液滴の寿命(s)
  late final double lifetime = _lifetime.elementAt(divisionCount);

  // 液滴の動きを進める
  Iterable<Spark> advance() {
    if (_isEndLifetime) {
      // 寿命が尽きていたら分裂か消滅する
      return _canDivide ? _dividedSparks : [];
    } else {
      // 寿命が尽きていなければ移動する
      return [_nextSpark];
    }
  }

  // ============== private ==================
  // 液滴が分裂可能か
  late final _canDivide = divisionCount < _maxDivisionCount;
  // 液滴の寿命が尽きていないか
  late final _isEndLifetime = lifetime < elapsedTime;

  // 1ミリ秒後の液滴
  late final Spark _nextSpark = Spark(
    divisionCount: divisionCount,
    velocity: velocity + _velocityChanges,
    accerelation: accerelation,
    elapsedTime: elapsedTime + _1milliSeconds,
    position: position + _positionChanges,
  );

  // 分裂後の液滴
  late final Iterable<Spark> _dividedSparks = [
    Spark(
      divisionCount: divisionCount + 1,
      velocity: velocity + _relativeVelocity1 + _velocityChanges,
      accerelation: accerelation,
      position: position + _positionChanges,
      elapsedTime: 0,
    ),
    Spark(
      divisionCount: divisionCount + 1,
      velocity: velocity + _relativeVelocity2 + _velocityChanges,
      accerelation: accerelation,
      position: position + _positionChanges,
      elapsedTime: 0,
    ),
  ];

  // 液滴分裂時の液滴に対する相対初速度
  late final Vector _relativeVelocity1 = () {
    final squaredVelocityAbs = _squaredInitialVelocity.elementAt(divisionCount);
    final xSquared = squaredVelocityAbs * random.nextDouble();
    final ySquared = (squaredVelocityAbs - xSquared) * random.nextDouble();
    final zSquared = squaredVelocityAbs - xSquared - ySquared;
    return Vector(
      sqrt(xSquared),
      sqrt(ySquared),
      sqrt(zSquared),
    );
  }();

  // 液滴分裂時の液滴に対する相対処速度2
  // 運動量保存より、2m0=mv1+mv2 => v1=-v2
  late final Vector _relativeVelocity2 = _relativeVelocity1 * -1;

  // 1millisec後の速度の変化量, Δv = a*t
  late final Vector _velocityChanges = accerelation * _1milliSeconds;

  // 1millisec後の位置の変化量
  late final Vector _positionChanges = Vector(
    _calcPositionChanges(position.x, accerelation.x),
    _calcPositionChanges(position.y, accerelation.z),
    _calcPositionChanges(position.z, accerelation.z),
  );

  // 位置の変化量を計算する r = r0*t + 1/2at^2
  double _calcPositionChanges(double p0, double a) =>
      p0 * _1milliSeconds + 0.5 * a * _squared1MilliSeconds;
}
