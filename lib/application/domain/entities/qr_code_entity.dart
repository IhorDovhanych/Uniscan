import 'package:equatable/equatable.dart';
import 'package:uniscan/application/data/models/geo_position.dart';

class QrCodeEntity extends Equatable {
  QrCodeEntity({
    required this.id,
    required this.name,
    required this.url,
    //required this.category,
    this.position,
    required this.createdAt,
    required this.updatedAt,
  }) : super();

  final String id;
  final String name;
  final String url;
  //final Category category;
  final GeoPositionModel? position;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object> get props {
    final propsList = [
      name,
      url,
      //category,
      createdAt,
      updatedAt
    ];

    if (position != null) {
      propsList
          .addAll([position!.latitude, position!.longitude, position!.meters]);
    }

    return propsList;
  }
}
