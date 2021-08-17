import 'package:sparkler/model/spark.dart';
import 'package:sparkler/model/vector.dart';

final windMaxVelocity = Vector.all(0.1);

class Wind {
  const Wind(this.velocity);
  final Vector velocity;

  factory Wind.init() => Wind(Vector.zero);

  Wind update() => Wind((velocity +
          Vector(
            _createRandomVelocity(),
            _createRandomVelocity(),
            _createRandomVelocity(),
          ))
      .maxByAbs(windMaxVelocity));

  double _createRandomVelocity() =>
      random.nextDouble() / 1000 * random.nextSign();
}
