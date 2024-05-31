import 'package:equatable/equatable.dart';

class GeoPositionEntity extends Equatable {
  const GeoPositionEntity({
    required this.latitude,
    required this.longitude,
    this.meters = 5,
  });

  final double latitude;
  final double longitude;
  final int meters;

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        meters,
      ];
}
