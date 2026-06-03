import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_bloc/generated/locale_keys.g.dart';
import 'package:go_router/go_router.dart';

import '../../../infrastructure/di/injection.dart';
import '../favourite/favourite_bloc.dart';
import '../favourite/favourite_event.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    // Favourites are shared across tab branches (the country list's toggle and
    // the favourites screen), so the bloc is provided at the shell — the lowest
    // common ancestor of those branches — not at the app root.
    return BlocProvider(
      create: (_) => FavouriteBloc(getIt())..add(const LoadFavouritesEvent()),
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: LocaleKeys.home.tr(context: context),
            icon: Padding(
              padding: .all(2.0),
              child: Icon(Icons.home_outlined),
            ),
          ),
          BottomNavigationBarItem(
            label: LocaleKeys.search.tr(context: context),
            icon: Padding(
              padding: .all(2.0),
              child: Icon(Icons.search_outlined),
            ),
          ),
          BottomNavigationBarItem(
            label: LocaleKeys.favourite.tr(context: context),
            icon: Padding(
              padding: .all(2.0),
              child: Icon(Icons.favorite_outline),
            ),
          ),
          BottomNavigationBarItem(
            label: LocaleKeys.setting.tr(context: context),
            icon: Padding(
              padding: .all(2.0),
              child: Icon(Icons.settings_outlined),
            ),
          ),
        ],
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        unselectedFontSize: 12,
        selectedFontSize: 12,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        onTap: (int index) => navigationShell.goBranch(index),
      ),
    );
  }
}
