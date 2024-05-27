import 'dart:ffi';
import 'package:flutter/foundation.dart';

@immutable
class QrCodeModel {
  QrCodeModel({
    this.id = '',
    required this.name,
    required this.url,
    this.position
  });

  factory QrCodeModel.fromJson(final Map<String, dynamic> json) => QrCodeModel(
        id: json['id'],
        name: json['name'],
        url: json['url'],
      );
  final String id;
  final String name;
  final String url;
  final List<Double>? position;
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
}
