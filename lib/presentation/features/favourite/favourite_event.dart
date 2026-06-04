import '../../../../domain/entities/country.dart';

sealed class FavouriteEvent {
  const FavouriteEvent();
}

class LoadFavouritesEvent extends FavouriteEvent {
  const LoadFavouritesEvent();
}

class AddFavouriteEvent extends FavouriteEvent {
  final Country country;
  const AddFavouriteEvent(this.country);
}

class RemoveFavouriteEvent extends FavouriteEvent {
  final Country country;
  const RemoveFavouriteEvent(this.country);
}
