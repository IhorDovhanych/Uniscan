import 'package:flutter/foundation.dart';

@immutable
class GeoLocationModel {

  GeoLocationModel(this.latitude, this.longitude, this.meters);

  final double latitude;
  final double longitude;
  final int meters;
}