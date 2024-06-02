import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.qrCodes,
  });

  final String id;
  final String name;
  final String email;
  final String avatar;
  final List<String> qrCodes;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatar,
        qrCodes,
      ];
}
