import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String condominiumId;
  final String apartment;
  final bool biometricEnabled;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.condominiumId,
    required this.apartment,
    required this.biometricEnabled,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? condominiumId,
    String? apartment,
    bool? biometricEnabled,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      condominiumId: condominiumId ?? this.condominiumId,
      apartment: apartment ?? this.apartment,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object> get props => [
    id,
    email,
    name,
    condominiumId,
    apartment,
    biometricEnabled,
    createdAt,
  ];
}
