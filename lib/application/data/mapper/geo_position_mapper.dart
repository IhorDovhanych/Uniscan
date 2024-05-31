import 'package:uniscan/application/data/models/geo_position.dart';
import 'package:uniscan/application/domain/entities/geo_position_entity.dart';

extension GeoPositionModelX on GeoPositionModel {
  GeoPositionEntity get toEntity => GeoPositionEntity(
        latitude: latitude,
        longitude: longitude,
        meters: meters,
      );
}

extension GeoPositionEntityX on GeoPositionEntity {
  GeoPositionModel get toModel => GeoPositionModel(
        latitude: latitude,
        longitude: longitude,
        meters: meters,
      );
}
