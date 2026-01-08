import 'package:condo_hub_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.condominiumId,
    required super.apartment,
    required super.biometricEnabled,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      condominiumId: json['condominiumId'] as String,
      apartment: json['apartment'] as String,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'condominiumId': condominiumId,
      'apartment': apartment,
      'biometricEnabled': biometricEnabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      condominiumId: entity.condominiumId,
      apartment: entity.apartment,
      biometricEnabled: entity.biometricEnabled,
      createdAt: entity.createdAt,
    );
  }
}
