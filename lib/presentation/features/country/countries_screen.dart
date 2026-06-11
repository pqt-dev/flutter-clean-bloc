import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_bloc/generated/locale_keys.g.dart';

import '../../../core/di/injection.dart';
import '../../core/error/app_error_message.dart';
import '../../core/widgets/app_loader.dart';
import 'country_cubit.dart';
import 'country_state.dart';
import 'widget/country_item_view.dart';

class CountriesScreen extends StatelessWidget {
  const CountriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CountryCubit(getIt())..loadCountries(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<CountryCubit, CountryState>(
            builder: (context, state) {
              return state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => const AppLoader(),
                data: (countries) => GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                  ),
                  itemBuilder: (context, index) =>
                      CountryItemView(data: countries[index]),
                  itemCount: countries.length,
                ),
                error: (error) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.0,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          error.localizedMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton.icon(
                          onPressed: () =>
                              context.read<CountryCubit>().loadCountries(),
                          icon: const Icon(Icons.refresh),
                          label: Text(LocaleKeys.retry.tr()),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
