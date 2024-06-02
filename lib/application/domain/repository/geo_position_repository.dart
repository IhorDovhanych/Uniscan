import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uniscan/core/error/base_exception.dart';

abstract class GeoPositionRepository {
  Future<Either<BaseException, Position?>> determinePosition();
}
