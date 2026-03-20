import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../country/widget/country_item_view.dart';
import 'favourite_bloc.dart';
import 'favourite_state.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite Countries')),
      body: SafeArea(
        child: BlocBuilder<FavouriteBloc, FavouriteState>(
          builder: (context, state) {
            if (state.favouriteCountries.isEmpty) {
              return const Center(child: Text('No favourite countries yet.'));
            }
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 24.0,
                crossAxisSpacing: 24.0,
              ),
              itemCount: state.favouriteCountries.length,
              itemBuilder: (context, index) {
                return CountryItemView(data: state.favouriteCountries[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
