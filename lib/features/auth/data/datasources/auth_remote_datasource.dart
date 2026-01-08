import 'package:condo_hub_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': 'user-1',
      'email': 'john.doe@email.com',
      'password': '123456',
      'name': 'João Silva',
      'condominiumId': 'condo-1',
      'apartment': '301',
      'biometricEnabled': false,
      'createdAt':
          DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
    },
    {
      'id': 'user-2',
      'email': 'jane.smith@email.com',
      'password': '123456',
      'name': 'Maria Santos',
      'condominiumId': 'condo-1',
      'apartment': '502',
      'biometricEnabled': false,
      'createdAt':
          DateTime.now().subtract(const Duration(days: 180)).toIso8601String(),
    },
    {
      'id': 'user-3',
      'email': 'michael.jones@email.com',
      'password': '123456',
      'name': 'Carlos Oliveira',
      'condominiumId': 'condo-2',
      'apartment': '1204',
      'biometricEnabled': false,
      'createdAt':
          DateTime.now().subtract(const Duration(days: 90)).toIso8601String(),
    },
  ];

  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    final userData = _mockUsers.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => throw Exception('E-mail ou senha inválidos'),
    );

    return UserModel.fromJson(userData);
  }
}
