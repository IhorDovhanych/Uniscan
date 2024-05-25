import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  const UserModel(
      {required this.id, required this.email, required this.name, required this.avatar, required this.qrCodes});

  factory UserModel.fromJson(final Map<String, dynamic> json) => UserModel(
        id: json['id'],
        email: json['email'] ?? '',
        name: json['name'] ?? '',
        avatar: json['avatar'] ?? '',
        qrCodes: json['qrCodes'] == null ? [] : List<String>.from(json['qrCodes'].map((final x) => x)),
      );

  final String id;
  final String email;
  final String name;
  final String avatar;
  final List<String> qrCodes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'avatar': avatar,
        'qrCodes': qrCodes,
      };
}
