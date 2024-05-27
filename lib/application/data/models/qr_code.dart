import 'package:flutter/foundation.dart';

@immutable
class QrCodeModel {
  QrCodeModel({
    required this.name,
    required this.url
  });

  factory QrCodeModel.fromJson(final Map<String, dynamic> json) => QrCodeModel(
        name: json['name'],
        url: json['url']
      );

  final String name;
  final String url;
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
