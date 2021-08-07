import 'package:sparkler/spark.dart';
import 'package:sparkler/vector.dart';

class Wind {
  const Wind(this.velocity);
  final Vector velocity;

  factory Wind.init() => Wind(Vector.zero());

  Wind update() => Wind(velocity +
      Vector(
        _createRandomVelocity(),
        // _createRandomVelocity(),
        0,
        _createRandomVelocity(),
      ));

  double _createRandomVelocity() =>
      random.nextDouble() / 10 * (random.nextBool() ? -1 : 1);
}
