import 'package:sparkler/spark.dart';

class SparkState {
  final sparks = [
    Spark(0, 0),
    Spark(10, 10),
    Spark(0, 20),
    Spark(30, 100),
    Spark(2, 40),
    Spark(200, 50),
    Spark(50, 400),
  ];

  void update() => sparks.forEach((e) => e.advance());
}
