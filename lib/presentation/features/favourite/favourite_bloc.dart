import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'favourite_event.dart';
import 'favourite_state.dart';

@lazySingleton
class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  FavouriteBloc() : super(const FavouriteState()) {
    on<AddFavouriteEvent>((event, emit) {
      if (!state.favouriteCountries.any((c) => c.name?.common == event.country.name?.common)) {
        final newList = List.of(state.favouriteCountries)..add(event.country);
        emit(state.copyWith(favouriteCountries: newList));
      }
    });

    on<RemoveFavouriteEvent>((event, emit) {
      final newList = state.favouriteCountries
          .where((c) => c.name?.common != event.country.name?.common)
          .toList();
      emit(state.copyWith(favouriteCountries: newList));
    });
  }
}
