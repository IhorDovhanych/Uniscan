import 'package:flutter/foundation.dart';

@immutable
class GeoPositionModel {
  GeoPositionModel(
      {required this.latitude, required this.longitude, this.meters = 5});

  final double latitude;
  final double longitude;
  final int meters;
}
