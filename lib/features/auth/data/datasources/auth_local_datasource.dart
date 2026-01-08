import 'dart:convert';
import 'package:condo_hub_app/features/auth/data/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCurrentUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser();
  Future<bool> isBiometricAvailable();
  Future<bool> authenticateWithBiometric();
  Future<void> enableBiometric(String userId);
  Future<void> disableBiometric(String userId);
  Future<bool> isBiometricEnabledForUser(String userId);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final LocalAuthentication localAuth;
  static const cachedUserKey = 'CACHED_USER';
  static const biometricEnabledPrefix = 'BIOMETRIC_ENABLED_';

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.localAuth,
  });

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final jsonString = sharedPreferences.getString(cachedUserKey);
      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString));
      }
      return null;
    } catch (e) {
      debugPrint('Error getting cached user: $e');
      return null;
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await sharedPreferences.setString(
        cachedUserKey,
        json.encode(user.toJson()),
      );
    } catch (e) {
      debugPrint('Error caching user: $e');
      throw Exception('Failed to cache user');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await sharedPreferences.remove(cachedUserKey);
    } catch (e) {
      debugPrint('Error clearing user: $e');
      throw Exception('Failed to clear user');
    }
  }

  @override
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheckBiometrics = await localAuth.canCheckBiometrics;
      final isDeviceSupported = await localAuth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }

  @override
  Future<bool> authenticateWithBiometric() async {
    try {
      return await localAuth.authenticate(
        localizedReason: 'Authenticate to access your condominium account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      debugPrint('Error authenticating with biometric: $e');
      return false;
    }
  }

  @override
  Future<void> enableBiometric(String userId) async {
    try {
      await sharedPreferences.setBool('$biometricEnabledPrefix$userId', true);
    } catch (e) {
      debugPrint('Error enabling biometric: $e');
      throw Exception('Failed to enable biometric');
    }
  }

  @override
  Future<void> disableBiometric(String userId) async {
    try {
      await sharedPreferences.remove('$biometricEnabledPrefix$userId');
    } catch (e) {
      debugPrint('Error disabling biometric: $e');
      throw Exception('Failed to disable biometric');
    }
  }

  @override
  Future<bool> isBiometricEnabledForUser(String userId) async {
    try {
      return sharedPreferences.getBool('$biometricEnabledPrefix$userId') ??
          false;
    } catch (e) {
      debugPrint('Error checking biometric status: $e');
      return false;
    }
  }
}
