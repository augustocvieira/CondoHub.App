import 'package:equatable/equatable.dart';

class Condominium extends Equatable {
  final String id;
  final String name;
  final String address;
  final String key;

  const Condominium({
    required this.id,
    required this.name,
    required this.address,
    required this.key,
  });

  @override
  List<Object> get props => [id, name, address, key];
}
