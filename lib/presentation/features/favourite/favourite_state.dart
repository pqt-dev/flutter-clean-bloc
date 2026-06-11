import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/entities/country.dart';

part 'favourite_state.freezed.dart';

@freezed
abstract class FavouriteState with _$FavouriteState {
  const FavouriteState._();

  const factory FavouriteState({
    @Default([]) List<Country> favouriteCountries,
  }) = _FavouriteState;

  bool contains(Country country) =>
      favouriteCountries.any((c) => c.isSameAs(country));
}
