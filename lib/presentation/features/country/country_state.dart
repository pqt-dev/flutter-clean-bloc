import 'package:flutter_clean_bloc_skeleton/domain/core/app_error.dart';
import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_state.freezed.dart';

@freezed
abstract class CountryState with _$CountryState {
  const factory CountryState.initial() = _Initial;
  const factory CountryState.loading() = _Loading;
  const factory CountryState.data(List<Country> countries) = _Data;
  const factory CountryState.error(AppError error) = _Error;
}