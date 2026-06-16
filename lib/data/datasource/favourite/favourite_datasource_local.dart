import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../domain/core/app_error.dart';
import '../../../domain/core/result.dart';
import '../../models/country/country_model.dart';
import 'favourite_datasource.dart';

@LazySingleton(as: FavouriteDatasource)
class FavouriteDatasourceLocal implements FavouriteDatasource {
  final SharedPreferences preferences;
  final Logger logger;

  FavouriteDatasourceLocal(this.preferences, this.logger);

  @override
  Future<Result<List<CountryModel>>> read() async {
    final raw = preferences.getString(StorageKeys.favouritesKey);
    if (raw == null || raw.isEmpty) return const Success([]);
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final models = decoded
          .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(models);
    } catch (e, stackTrace) {
      logger.e('Failed to decode favourites', error: e, stackTrace: stackTrace);
      return Failure(ParsingError(cause: e, stackTrace: stackTrace));
    }
  }

  @override
  Future<Result<void>> write(List<CountryModel> countries) async {
    try {
      final encoded = jsonEncode(countries.map((c) => c.toJson()).toList());
      await preferences.setString(StorageKeys.favouritesKey, encoded);
      return const Success<void>(null);
    } catch (e, stackTrace) {
      logger.e('Failed to save favourites', error: e, stackTrace: stackTrace);
      return Failure(UnexpectedError(cause: e, stackTrace: stackTrace));
    }
  }
}
