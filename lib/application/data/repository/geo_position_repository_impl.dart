import 'package:dartz/dartz.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:uniscan/application/data/services/geo_position_service.dart';
import 'package:uniscan/application/domain/repository/geo_position_repository.dart';
import 'package:uniscan/core/error/base_exception.dart';
import 'package:uniscan/core/error/error_codes.dart';
import 'package:uniscan/core/utils/print_utils.dart';

class GeoPositionRepositoryImpl extends GeoPositionRepository {
  GeoPositionRepositoryImpl(this._geoPositionService);

  final GeoPositionService _geoPositionService;

  @override
  Future<Either<BaseException, Position?>> determinePosition() async {
    try {
      final position = await _geoPositionService.determinePosition();
      return Right(position);
    } catch (e, st) {
      const message = 'Failed to determinePosition';
      printError(message, e, st);
      return Left(
          BaseException(error: e, stack: st, code: ecNonDio, message: message));
    }
  }
}
