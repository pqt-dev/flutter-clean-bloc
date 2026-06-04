import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/favourite/favourite_use_case.dart';
import '../../core/bloc/event_transformers.dart';
import 'favourite_event.dart';
import 'favourite_state.dart';

/// App-wide favourites shared between the country list and the favourites
/// screen, persisted locally via [FavouriteUseCase]. Its lifecycle is owned by
/// the root [BlocProvider] (not a GetIt singleton), so the provider creates and
/// closes the single instance. Dispatch [LoadFavouritesEvent] once on creation
/// to restore the persisted list.
class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final FavouriteUseCase _useCase;

  FavouriteBloc(this._useCase) : super(const FavouriteState()) {
    on<LoadFavouritesEvent>((event, emit) async {
      final favourites = await _useCase.getFavourites();
      emit(state.copyWith(favouriteCountries: favourites));
    });

    on<AddFavouriteEvent>((event, emit) async {
      final newList = await _useCase.add(state.favouriteCountries, event.country);
      emit(state.copyWith(favouriteCountries: newList));
    }, transformer: sequential());

    on<RemoveFavouriteEvent>((event, emit) async {
      final newList = await _useCase.remove(
        state.favouriteCountries,
        event.country,
      );
      emit(state.copyWith(favouriteCountries: newList));
    }, transformer: sequential());
  }
}
