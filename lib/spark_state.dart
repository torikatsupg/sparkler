import 'package:sparkler/spark.dart';
import 'package:vector_math/vector_math.dart';

final gravity = Vector3(0, 9.8, 0);
final v0 = Vector3(20, 10, 0);
final p0 = Vector3(100, 100, 0);

class SparkState {
  List<Spark> sparks = [
    Spark(acceraration: gravity, velocity: v0, position: p0)
  ];

  void update() {
    final nextSparks = sparks.map((e) => e.advance()).expand((e) => e);
    sparks = [...nextSparks];
  }
}
