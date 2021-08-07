import 'dart:math';

class MyRandom {
  static final _random = Random();

  int nextInt(int max) => max <= 0 ? 0 : _random.nextInt(max);

  double nextIntAsDouble(int max) => nextInt(max).toDouble();

  double nextIntAsDoubleWith(double max) => nextInt(max.toInt()).toDouble();

  double nextDouble() => _random.nextDouble();

  bool nextBool() => _random.nextBool();

  // 正負をランダムに返す
  int nextSign() => _random.nextBool() ? -1 : 1;
}
