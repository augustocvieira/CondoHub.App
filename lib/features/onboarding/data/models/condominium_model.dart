import 'package:condo_hub_app/features/onboarding/domain/entities/condominium.dart';

class CondominiumModel extends Condominium {
  const CondominiumModel({
    required super.id,
    required super.name,
    required super.address,
    required super.key,
  });

  factory CondominiumModel.fromJson(Map<String, dynamic> json) {
    return CondominiumModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      key: json['key'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'key': key,
    };
  }

  factory CondominiumModel.fromEntity(Condominium entity) {
    return CondominiumModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      key: entity.key,
    );
  }
}
