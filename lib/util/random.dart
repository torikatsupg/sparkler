import 'dart:math';

import 'package:sparkler/model/spark.dart';
import 'package:sparkler/model/vector.dart';

class MyRandom {
  static final _random = Random();

  int nextInt(int max) => max <= 0 ? 0 : _random.nextInt(max);

  double nextIntAsDouble(int max) => nextInt(max).toDouble();

  double nextIntAsDoubleWith(double max) => nextInt(max.toInt()).toDouble();

  double nextDoubleInclude1() => _random.nextDouble() + 1;

  double nextIntAsDoubleWithSign(int max) => nextIntAsDouble(max) * nextSign();

  double Function() nextIntAsDoubleWithSignGenerator(int max) =>
      () => nextIntAsDoubleWithSign(max);

  double nextDouble() => _random.nextDouble();

  bool nextBool() => _random.nextBool();

  // 正負をランダムに返す
  int nextSign() => _random.nextBool() ? -1 : 1;

  // 値をランダムに3分割する(符号もランダム)
  Vector splitValue(double value) {
    final a = random.nextDouble();
    final b = random.nextDouble();
    final c = random.nextDouble();
    final total = a + b + c;
    return Vector(
      value * a / total,
      value * b / total,
      value * c / total,
    );
  }
}
