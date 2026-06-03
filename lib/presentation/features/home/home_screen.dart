import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_bloc/generated/locale_keys.g.dart';
import 'package:flutter_clean_bloc/presentation/core/widgets/app_button.dart';
import 'package:flutter_clean_bloc/presentation/router/app_routes.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              AppButton(
                title: LocaleKeys.go_to_countries.tr(),
                onPressed: () => context.push(AppRoutes.countriesInHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
