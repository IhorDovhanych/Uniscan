import 'package:flutter/foundation.dart';
import 'package:uniscan/application/data/models/geo_position.dart';

@immutable
class QrCodeModel {
  QrCodeModel(
      {this.id = '', required this.name, required this.url, this.geoPosition});

  factory QrCodeModel.fromJson(final Map<String, dynamic> json) => QrCodeModel(
        id: json['id'],
        name: json['name'],
        url: json['url'],
      );
  final String id;
  final String name;
  final String url;
  final GeoPositionModel? geoPosition;
  final DateTime createdAt = DateTime.now();
  final DateTime updatedAt = DateTime.now();

  static final RegExp urlRegex = RegExp(
      r'^(?:http|https):\/\/(?:www\.)?[a-zA-Z0-9\-\._]+(?:\.[a-zA-Z]{2,})+(?:\/[^\s]*)?$');

  bool isValidUrl() => urlRegex.hasMatch(url);

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  void validateUrl() {
    if (!isValidUrl()) {
      throw ArgumentError('Invalid URL: $url');
    }
  }

  QrCodeModel copyWith({
    final String? id,
    final String? name,
    final String? url,
    final GeoPositionModel? geoPosition,
  }) =>
      QrCodeModel(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        geoPosition: geoPosition ?? this.geoPosition,
      );
}
