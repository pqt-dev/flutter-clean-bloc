import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/country.dart';
import '../favourite_bloc.dart';
import '../favourite_event.dart';
import '../favourite_state.dart';

/// Public favourite toggle owned by the favourite feature.
///
/// Other features compose this widget instead of reaching into
/// [FavouriteBloc]/[FavouriteEvent]/[FavouriteState] directly.
class FavouriteToggleButton extends StatelessWidget {
  const FavouriteToggleButton({super.key, required this.country});

  final Country country;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavouriteBloc, FavouriteState, bool>(
      selector: (state) => state.favouriteCountries
          .any((c) => c.cca3 != null && c.cca3 == country.cca3),
      builder: (context, isFavourite) {
        return IconButton(
          icon: Icon(
            isFavourite ? Icons.favorite : Icons.favorite_border,
            color: isFavourite ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            final bloc = context.read<FavouriteBloc>();
            if (isFavourite) {
              bloc.add(RemoveFavouriteEvent(country));
            } else {
              bloc.add(AddFavouriteEvent(country));
            }
          },
        );
      },
    );
  }
}
