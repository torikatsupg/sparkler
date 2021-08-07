import 'package:sparkler/model/spark.dart';
import 'package:sparkler/model/vector.dart';

final windMaxVelocity = Vector.all(1.5);

class Wind {
  const Wind(this.velocity);
  final Vector velocity;

  factory Wind.init() => Wind(Vector.zero());

  Wind update() => Wind(
      (velocity + Vector(_createRandomVelocity(), 0, _createRandomVelocity()))
          .maxByAbs(windMaxVelocity));

  double _createRandomVelocity() =>
      random.nextDouble() / 5 * (random.nextBool() ? -1 : 1);
}
