import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/entities/country.dart';

part 'favourite_state.freezed.dart';

@freezed
abstract class FavouriteState with _$FavouriteState {
  const factory FavouriteState({
    @Default([]) List<Country> favouriteCountries,
  }) = _FavouriteState;
}
