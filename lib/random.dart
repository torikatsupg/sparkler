import 'dart:math';

class MyRandom {
  static final _random = Random();

  int nextInt(int max) {
    if (max.isNaN) {
      return 0;
    } else if (max <= 0) {
      return 0;
    } else {
      return _random.nextInt(max);
    }
  }

  double nextDouble() => _random.nextDouble();

  bool nextBool() => _random.nextBool();
}
