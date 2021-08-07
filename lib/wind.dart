import 'dart:math';

import 'package:sparkler/spark.dart';
import 'package:vector_math/vector_math.dart';

class Wind {
  const Wind(this.velocity);
  final Vector3 velocity;

  factory Wind.init() => Wind(Vector3.all(0));

  Wind update() => Wind(Vector3(
        _createRandomVelocity(),
        _createRandomVelocity(),
        _createRandomVelocity(),
      ));

  double _createRandomVelocity() =>
      random.nextInt(100) / 100 * (random.nextBool() ? -1 : 1);
}
