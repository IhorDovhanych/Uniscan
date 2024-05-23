import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class QrCodeEntity extends Equatable {
  final String name;
  final String url;
  final String category;
  final Position position;
  final DateTime createdAt;
  final DateTime updatedAt;

  RegExp urlRegex = RegExp(
      r'^(?:http|https):\/\/(?:www\.)?[a-zA-Z0-9\-\._]+(?:\.[a-zA-Z]{2,})+(?:\/[^\s]*)?$');

  QrCodeEntity({
    required this.name,
    required this.url,
    required this.category,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  }) : super() {
    if (!isValidUrl(url)) {
      throw ArgumentError('Invalid URL: $url');
    }
  }
  
  bool isValidUrl(String url) {
    return urlRegex.hasMatch(url);
  }

  @override
  List<Object> get props =>
      [name, url, category, position, createdAt, updatedAt];
}
