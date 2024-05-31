import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uniscan/application/data/models/geo_position.dart';

@immutable
class QrCodeModel {
  QrCodeModel({
    required this.id,
    required this.name,
    required this.url,
    this.geoPosition,
    required this.creatorId,
    this.createdAt,
    this.updatedAt,
  });

  factory QrCodeModel.fromJson(final Map<String, dynamic> json) => QrCodeModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        url: json['url'] ?? '',
        creatorId: json['creatorId'] ?? '',
        geoPosition: json['geoPosition'] != null ? GeoPositionModel.fromJson(json['geoPosition']) : null,
        createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : null,
        updatedAt: json['updatedAt'] != null ? (json['updatedAt'] as Timestamp).toDate() : null,
      );

  final String id;
  final String name;
  final String url;
  final GeoPositionModel? geoPosition;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String creatorId;

  static final RegExp urlRegex =
      RegExp(r'^(?:http|https):\/\/(?:www\.)?[a-zA-Z0-9\-\._]+(?:\.[a-zA-Z]{2,})+(?:\/[^\s]*)?$');

  bool isValidUrl() => urlRegex.hasMatch(url);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'creatorId': creatorId,
        if (createdAt != null) 'createdAt': createdAt!,
        if (updatedAt != null) 'updatedAt': updatedAt!,
        if (geoPosition != null) 'geoPosition': geoPosition!.toMap(),
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
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? creatorId,
  }) =>
      QrCodeModel(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        geoPosition: geoPosition ?? this.geoPosition,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        creatorId: creatorId ?? this.creatorId,
      );
}
