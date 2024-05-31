import 'package:equatable/equatable.dart';
import 'package:uniscan/application/domain/entities/geo_position_entity.dart';

class QrCodeEntity extends Equatable {
  const QrCodeEntity({
    required this.id,
    required this.name,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.creatorId,
    required this.geoPosition,
  });

  factory QrCodeEntity.empty() => const QrCodeEntity(
        id: '',
        name: '',
        url: '',
        createdAt: null,
        updatedAt: null,
        creatorId: '',
        geoPosition: null,
      );

  final String id;
  final String name;
  final String url;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String creatorId;
  final GeoPositionEntity? geoPosition;

  @override
  List<Object?> get props => [
        id,
        name,
        url,
        createdAt,
        updatedAt,
        creatorId,
        geoPosition,
      ];

  QrCodeEntity copyWith({
    final String? id,
    final String? name,
    final String? url,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? creatorId,
    final GeoPositionEntity? geoPosition,
  }) =>
      QrCodeEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        creatorId: creatorId ?? this.creatorId,
        geoPosition: geoPosition ?? this.geoPosition,
      );
}
