import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class QrCodeEntity extends Equatable {
  final String name;
  final String url;
  //final String category;
  final Position position;
  final DateTime createdAt;
  final DateTime updatedAt;

  QrCodeEntity({
    required this.name,
    required this.url,
    //required this.category,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  }) : super();

  @override
  List<Object> get props => [
        name,
        url,
        //category,
        position,
        createdAt,
        updatedAt
      ];
}
