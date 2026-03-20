import 'package:flutter_clean_bloc/domain/entities/country.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_state.freezed.dart';

@freezed
abstract class CountryState with _$CountryState {
  const factory CountryState.initial() = _Initial;
  const factory CountryState.loading() = _Loading;
  const factory CountryState.data(List<Country> countries) = _Data;
  const factory CountryState.error(String message) = _Error;
}