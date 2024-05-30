import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';

extension QrCodeEntityX on QrCodeEntity {
  QrCodeModel get toModel => QrCodeModel(
        id: id, // Якщо потрібно, заповніть ідентифікатор
        name: name,
        url: url,
        geoPosition: geoPosition,
      );
}

extension QrCodeModelX on QrCodeModel {
  QrCodeEntity get toEntity => QrCodeEntity(
        id: id,
        name: name,
        url: url,
        geoPosition: geoPosition,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
