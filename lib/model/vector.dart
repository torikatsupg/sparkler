import 'package:vector_math/vector_math.dart';

class Vector {
  Vector(double x, double y, double z) : this._vector = Vector3(x, y, z);

  factory Vector.zero() => Vector(0, 0, 0);
  factory Vector.all(double value) => Vector(value, value, value);

  Vector.fromVector3(this._vector);

  final Vector3 _vector;

  double get x => _vector.isNaN ? 0 : _vector.x;
  double get y => _vector.isNaN ? 0 : _vector.y;
  double get z => _vector.isNaN ? 0 : _vector.z;

  Vector operator *(double scale) => Vector.fromVector3(_vector * scale);
  Vector operator /(double scale) => Vector.fromVector3(_vector / scale);
  Vector operator +(Vector vector) =>
      Vector.fromVector3(_vector + vector._vector);
  Vector operator -(Vector vector) =>
      Vector.fromVector3(_vector - vector._vector);

  Vector maxByAbs(Vector max) =>
      Vector(_maxByAds(x, max.x), _maxByAds(y, max.y), _maxByAds(z, max.z));

  double _maxByAds(double next, double max) {
    if (next.abs() > max) {
      return max;
    } else {
      return next;
    }
  }
}
