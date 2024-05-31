import 'package:uniscan/application/data/mapper/geo_position_mapper.dart';
import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';

extension QrCodeEntityX on QrCodeEntity {
  QrCodeModel get toModel => QrCodeModel(
        id: id, // Якщо потрібно, заповніть ідентифікатор
        name: name,
        url: url,
        geoPosition: geoPosition?.toModel,
        creatorId: creatorId,
      );
}

extension QrCodeModelX on QrCodeModel {
  QrCodeEntity get toEntity => QrCodeEntity(
        id: id,
        name: name,
        url: url,
        geoPosition: geoPosition?.toEntity,
        createdAt: createdAt,
        updatedAt: updatedAt,
        creatorId: creatorId,
      );
}
