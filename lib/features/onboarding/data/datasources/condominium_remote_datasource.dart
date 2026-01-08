import 'package:condo_hub_app/features/onboarding/data/models/condominium_model.dart';

abstract class CondominiumRemoteDataSource {
  Future<CondominiumModel> identifyByQRCode(String qrData);
  Future<CondominiumModel> identifyByKey(String key);
}

class CondominiumRemoteDataSourceImpl implements CondominiumRemoteDataSource {
  final List<CondominiumModel> _mockCondominiums = [
    const CondominiumModel(
      id: 'condo-1',
      name: 'Residencial Sunset',
      address: 'Rua das Palmeiras, 123 - São Paulo, SP',
      key: 'SUNSET2024',
    ),
    const CondominiumModel(
      id: 'condo-2',
      name: 'Torres Vista Mar',
      address: 'Avenida Beira Mar, 456 - Rio de Janeiro, RJ',
      key: 'VISTAMAR2024',
    ),
    const CondominiumModel(
      id: 'condo-3',
      name: 'Edifício Parque Verde',
      address: 'Rua dos Jardins, 789 - Curitiba, PR',
      key: 'PARQVERDE2024',
    ),
  ];

  @override
  Future<CondominiumModel> identifyByQRCode(String qrData) async {
    await Future.delayed(const Duration(seconds: 1));

    final condominium = _mockCondominiums.firstWhere(
      (c) => c.id == qrData || c.key == qrData,
      orElse: () => throw Exception('Condomínio não encontrado'),
    );

    return condominium;
  }

  @override
  Future<CondominiumModel> identifyByKey(String key) async {
    await Future.delayed(const Duration(seconds: 1));

    final condominium = _mockCondominiums.firstWhere(
      (c) => c.key.toLowerCase() == key.toUpperCase(),
      orElse: () => throw Exception('Chave do condomínio inválida'),
    );

    return condominium;
  }
}
