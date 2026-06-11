import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/country.dart';
import '../../../domain/repositories/favourite/favourite_repository.dart';
import '../../../core/constants/storage_keys.dart';
import '../../mappers/country_mapper.dart';
import '../../models/country/country_model.dart';

final _logger = Logger();

@LazySingleton(as: FavouriteRepository)
class FavouriteRepositoryImpl implements FavouriteRepository {
  final SharedPreferences preferences;

  FavouriteRepositoryImpl(this.preferences);

  @override
  Future<List<Country>> getFavourites() async {
    final raw = preferences.getString(StorageKeys.favouritesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => CountryModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
    } catch (e, stackTrace) {
      _logger.e('Failed to decode favourites', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<void> saveFavourites(List<Country> countries) async {
    try {
      final encoded = jsonEncode(
        countries.map((c) => c.toModel().toJson()).toList(),
      );
      await preferences.setString(StorageKeys.favouritesKey, encoded);
    } catch (e, stackTrace) {
      _logger.e('Failed to save favourites', error: e, stackTrace: stackTrace);
    }
  }
}
