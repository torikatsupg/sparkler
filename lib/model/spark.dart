import 'dart:math';

import 'package:sparkler/model/particle.dart';
import 'package:sparkler/util/random.dart';
import 'package:sparkler/model/vector.dart';

class Spark {
  // コンストラクタ
  Spark({
    required this.divisionCount,
    required this.velocity,
    required this.accerelation,
    required this.position,
    required this.prevPosition,
    required this.elapsedTime,
  });

  // 液滴の作成
  factory Spark.init(Vector windVelocity) {
    final divisionCount = random.nextInt(8);
    return Spark(
      divisionCount: divisionCount,
      velocity: Spark._calcRandomVelocityWith(divisionCount) + windVelocity,
      accerelation: _gravityAcceralation,
      position: Vector.zero,
      prevPosition: Vector.zero,
      elapsedTime: 0,
    );
  }

  // 分裂回数
  final int divisionCount;
  // 初速度
  final Vector velocity;
  // 加速度
  final Vector accerelation;
  // 位置
  final Vector position;
  // 直前の位置
  final Vector prevPosition;
  // 液滴が生成されてから経過した時間(s)
  final double elapsedTime;

  // 1ミリ秒後の経過時間
  late final double _nextElapsedTime = elapsedTime + _1milliSeconds;

  // 液滴の直径
  late final double _deameter = _deameters[divisionCount];
  // 液滴の寿命(s)
  late final double lifetime = _lifetimes[divisionCount];

  // 液滴の動きを1ミリ秒進める
  Iterable<Spark> advance(Vector windVelocity) {
    // 風速の影響は次のadvanceで反映される
    if (_isEndLifetime) {
      // 寿命が尽きていたら分裂か消滅する
      if (_canDivide) {
        return [
          Spark(
            divisionCount: divisionCount + 1,
            velocity:
                velocity + _relativeVelocity1 + windVelocity + _velocityChanges,
            accerelation: accerelation,
            position: position + _positionChanges,
            prevPosition: position,
            elapsedTime: 0,
          ),
          Spark(
            divisionCount: divisionCount + 1,
            velocity:
                velocity + _relativeVelocity2 + windVelocity + _velocityChanges,
            accerelation: accerelation,
            position: position + _positionChanges,
            prevPosition: position,
            elapsedTime: 0,
          ),
        ];
      } else {
        return [];
      }
    } else {
      // 寿命が尽きていなければ移動する
      return [
        Spark(
          divisionCount: divisionCount,
          velocity: velocity + _velocityChanges + windVelocity,
          accerelation: accerelation,
          position: position + _positionChanges,
          prevPosition: position,
          elapsedTime: _nextElapsedTime,
        )
      ];
    }
  }

  // パーティクルを生成する
  Particle toParticle() => Particle(
        position: position,
        prevPosition: prevPosition,
        deameter: _deameter,
        lifetime: lifetime,
        elapsedTime: elapsedTime,
      );

  // ============== private ==================
  // 液滴が分裂可能か
  late final _canDivide = divisionCount < _maxDivisionCount;
  // 液滴の寿命が尽きていないか
  late final _isEndLifetime = lifetime < elapsedTime;

  // 液滴分裂時の液滴に対する相対初速度
  late final Vector _relativeVelocity1 = _calcRandomVelocityWith(divisionCount);

  static Vector _calcRandomVelocityWith(int divisionCount) {
    final squaredVelocityAbs = _squaredInitialVelocities[divisionCount];
    final xSquared = squaredVelocityAbs * random.nextDouble();
    final ySquared = (squaredVelocityAbs - xSquared) * random.nextDouble();
    final zSquared = squaredVelocityAbs - xSquared - ySquared;
    return Vector(
      sqrt(xSquared) * random.nextSign(),
      sqrt(ySquared) * random.nextSign(),
      sqrt(zSquared) * random.nextSign(),
    );
  }

  // 液滴分裂時の液滴に対する相対処速度2
  // 運動量保存より、2m0=mv1+mv2 => v1=-v2
  late final Vector _relativeVelocity2 = _relativeVelocity1 * -1;

  // 1millisec後の速度の変化量, Δv = a*t
  late final Vector _velocityChanges = accerelation * _1milliSeconds;

  // 1millisec後の位置の変化量
  late final Vector _positionChanges = Vector(
    _calcPositionChanges(velocity.x, accerelation.x),
    _calcPositionChanges(velocity.y, accerelation.z),
    _calcPositionChanges(velocity.z, accerelation.z),
  );

  // 位置の変化量を計算する r = r0*t + 1/2at^2
  double _calcPositionChanges(double v0, double a) =>
      v0 * _1milliSeconds + 0.5 * a * _squared1MilliSeconds;
}

// ランダム
final random = MyRandom();
// 重力加速度(kg/s^2)
final _gravityAcceralation = Vector(0, 9.8, 0);
// 1ミリ秒(s)
const _1milliSeconds = 0.01;
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
const _divisionCounter = [0, 1, 2, 3, 4, 5, 6, 7, 8];
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
final _radii = _divisionCounter.map(_calcRadius).toList();
// 分裂回数ごとの直径の半径
final _deameters = _radii.map((e) => e * 2).toList();
// 分裂回数ごとの液滴の寿命
final _lifetimes = _divisionCounter.map(_calcLifitime).toList();
// 分裂回数ごとの液滴の初速の二乗値
final _squaredInitialVelocities =
    _divisionCounter.map(_calcSquaredInitialVelocity).toList();
