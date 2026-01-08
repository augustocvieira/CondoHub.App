import 'dart:convert';
import 'package:condo_hub_app/features/onboarding/data/models/condominium_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CondominiumLocalDataSource {
  Future<CondominiumModel?> getSelectedCondominium();
  Future<void> cacheCondominium(CondominiumModel condominium);
}

class CondominiumLocalDataSourceImpl implements CondominiumLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const cachedCondominiumKey = 'CACHED_CONDOMINIUM';

  CondominiumLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<CondominiumModel?> getSelectedCondominium() async {
    try {
      final jsonString = sharedPreferences.getString(cachedCondominiumKey);
      if (jsonString != null) {
        return CondominiumModel.fromJson(json.decode(jsonString));
      }
      return null;
    } catch (e) {
      debugPrint('Error getting cached condominium: $e');
      return null;
    }
  }

  @override
  Future<void> cacheCondominium(CondominiumModel condominium) async {
    try {
      await sharedPreferences.setString(
        cachedCondominiumKey,
        json.encode(condominium.toJson()),
      );
    } catch (e) {
      debugPrint('Error caching condominium: $e');
      throw Exception('Failed to cache condominium');
    }
  }
}
