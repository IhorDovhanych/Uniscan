import 'package:flutter/foundation.dart';

@immutable
class GeoPositionModel {
  GeoPositionModel({
    required this.latitude,
    required this.longitude,
    this.meters = 5,
  });

  factory GeoPositionModel.fromJson(final Map<String, dynamic> json) => GeoPositionModel(
        latitude: json['latitude'],
        longitude: json['longitude'],
        meters: json['meters'],
      );

  final double latitude;
  final double longitude;
  final int meters;

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
        'meters': meters,
      };
}
