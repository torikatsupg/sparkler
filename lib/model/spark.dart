import 'dart:math';

import 'package:sparkler/model/particle.dart';
import 'package:sparkler/util/random.dart';
import 'package:sparkler/model/vector.dart';

// ランダム
final random = MyRandom();

class Spark {
  Spark._({
    required this.acceraration,
    required this.velocity,
    required this.position,
    this.duration = 0,
    required this.mass,
    required this.ancestorMass,
  });

  factory Spark.create() {
    final initialMass = random.nextDoubleInclude1() * _maxInitialMass;
    return Spark._(
      acceraration: Spark._gravity,
      velocity: Vector.each(
          random.nextIntAsDoubleWithSignGenerator(_maxInitialVelocity)),
      position: Vector.zero,
      mass: initialMass,
      ancestorMass: initialMass,
    );
  }

  // 重力加速度(kg/s^2)
  static final _gravity = Vector(0, 9.8, 0);
  // 火球から発生する火花の最大初速度(m/s)
  static const _maxInitialVelocity = 100;
  // 火球から発生する火花の最大質量(kg) 0.00001kg = 10mg
  static const _maxInitialMass = 0.00001;
  // 火花の最小質量(kg) 0.000001kg = 1mg
  static const _minMass = 0.000001;

  // 1フレームの秒数(s)
  // 1F = 0.0017s
  static const _secondsPerFrame = 0.017;
  // 1フレーム中に火花一個に対して描画するパーティクルの数(個)
  // 0.001sごとに一個描画するため、1F=0.017sより 0.017s / 0.001s = 17
  static const _particlesPerFrame = 17;
  // 1フレームごとの相対時間(s)
  // フレームの開始を0sとし、0.001sづつ積み上げる
  static final _durationInFrame = Iterable.generate(
      (_particlesPerFrame).toInt(),
      (i) => _SecondsAndProgress(i / 1000, i / _particlesPerFrame));

  // 火花の加速度(m/s^2)
  final Vector acceraration;
  // 火花の速度(m/s)
  final Vector velocity;
  // 火花の位置
  final Vector position;
  // 火花が発生してからの経過時間(s)
  final double duration;
  // 火花の質量(kg)
  final double mass;
  // 分裂前の火花の質量(kg)
  final double ancestorMass;

  // 火花の寿命
  // 線香花火の燃焼時間を40sとする
  // 線香花火の火薬の質量を0.001kg(0.1g)とし、一定の速度で燃焼すると仮定すると
  // 0.001kg : 40s = mass(kg): lifetime(s)
  // lifetime =
  // 0.5g : 40s = mass g : lifetime より、 lifetime = mass / 0.001 * 80
  late final double lifetime = 40000 * mass;

  // 火花の直径
  // 硝酸カリウムの密度は2.11g/cm^3より V = m /2.11
  // 球体の体積は V = 3/4πr^3より、r= √(3){4V/(3π)}
  // よって r(m) = √(3) { 4 * mass / 2.11 /(3 * π) }
  late final double diameter = pow(_calcDiameterConstant * mass, _1Divid3) * 2;
  // 定数はキャッシュしておく
  static const _1Divid3 = 1 / 3;
  static const _calcDiameterConstant = 4 / (3 * pi * 2.11);

  // 火花に発生する空気抵抗の係数
  // 空気抵抗は質量の2/3乗になる
  late final double k = pow(mass, _2Divid3) as double;
  // 定数をキャッシュしておく
  static const _2Divid3 = 2 / 3;

  // 火花の動きを進める
  Iterable<Spark> advance(Vector windVelocity) {
    // 火花の質量が最小質量を下回ったら火花を消す
    if (mass < _minMass) {
      return [];
    }

    final nextDuration = duration + _secondsPerFrame;
    // 火花の寿命が尽きたら分裂する
    if (nextDuration >= lifetime) {
      return _divide(windVelocity);
    }

    // 火花を移動する
    return [_move(nextDuration, windVelocity)];
  }

  // パーティクルを作成する
  // パーティクルは1Fあたり17個作成する
  Iterable<Particle> toParticles(Vector windVelocity) {
    final generator = _particleGenerator(windVelocity);
    return _durationInFrame.map(generator);
  }

  _ParticleGenerator _particleGenerator(Vector windVelocity) {
    return (_SecondsAndProgress secondsAndProgress) {
      final particleVelocity = _calcVelocity(
          velocity, windVelocity, acceraration, secondsAndProgress.seconds);

      final particlePosition = _calcPosition(
        position,
        mass,
        particleVelocity,
        windVelocity,
        secondsAndProgress.seconds,
        acceraration,
      );

      return Particle(
        particlePosition,
        diameter,
        secondsAndProgress.pregress,
      );
    };
  }

  // 火花を1フレーム進める
  Spark _move(double nextDuration, Vector windVelocity) => Spark._(
        acceraration: _gravity,
        velocity: _calcVelocity(
            velocity, windVelocity, acceraration, _secondsPerFrame),
        position: _calcPosition(position, mass, velocity, windVelocity,
            _secondsPerFrame, acceraration),
        duration: nextDuration,
        mass: mass,
        ancestorMass: ancestorMass,
      );

  // 火花を分裂させる
  List<Spark> _divide(windVelocity) {
    // 分裂後の質量を計算
    final mass1 = mass * random.nextDouble();
    final mass2 = mass == mass1 ? _minMass : mass - mass1; // 質量が0にならないようにする

    // 分裂後の質量を計算
    final velocity1 = Vector(
      random.nextDouble() * velocity.x,
      random.nextDouble() * velocity.y,
      random.nextDouble() * velocity.z,
    );
    // 運動量保存より速度を計算
    final velocity2 = (velocity * mass - velocity1 * mass1) / mass2;

    // 分裂後の2つの火花の初期位置を計算
    final nextPosition = _calcPosition(
        position, mass, velocity, windVelocity, _secondsPerFrame, acceraration);

    return [
      Spark._(
        acceraration: _gravity,
        velocity: velocity1,
        position: nextPosition,
        mass: mass1,
        ancestorMass: mass,
      ),
      Spark._(
        acceraration: _gravity,
        velocity: velocity2,
        position: nextPosition,
        mass: mass2,
        ancestorMass: mass,
      ),
    ];
  }

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

class _SecondsAndProgress {
  const _SecondsAndProgress(this.seconds, this.pregress);
  final double seconds;
  final double pregress;
}

typedef _ParticleGenerator = Particle Function(
    _SecondsAndProgress secondsAndProgress);
