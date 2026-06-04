import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/locale_keys.g.dart';
import '../../theme/theme_cubit.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  String _themeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => LocaleKeys.theme_light.tr(),
      ThemeMode.dark => LocaleKeys.theme_dark.tr(),
      ThemeMode.system => LocaleKeys.theme_system.tr(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.setting.tr()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SettingTile(
                label: LocaleKeys.language.tr(),
                trailing: DropdownButton<Locale>(
                  value: context.locale,
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      context.setLocale(newLocale);
                    }
                  },
                  items: context.supportedLocales.map((locale) {
                    return DropdownMenuItem<Locale>(
                      value: locale,
                      child: Text(locale.languageCode.toUpperCase()),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16.0),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, mode) {
                  return _SettingTile(
                    label: LocaleKeys.theme.tr(),
                    trailing: DropdownButton<ThemeMode>(
                      value: mode,
                      onChanged: (ThemeMode? newMode) {
                        if (newMode != null) {
                          context.read<ThemeCubit>().setTheme(newMode);
                        }
                      },
                      items: ThemeMode.values.map((m) {
                        return DropdownMenuItem<ThemeMode>(
                          value: m,
                          child: Text(_themeLabel(m)),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.label, required this.trailing});

  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        trailing,
      ],
    );
  }
}
