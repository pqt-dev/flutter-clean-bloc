import 'package:flutter/material.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/app_theme_mode.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';
import 'package:flutter_clean_bloc_skeleton/domain/repositories/theme/theme_repository.dart';
import 'package:flutter_clean_bloc_skeleton/presentation/theme/theme_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'theme_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ThemeRepository>()])
void main() {
  late MockThemeRepository repository;
  late ThemeCubit cubit;

  setUpAll(() {
    provideDummy<Result<AppThemeMode>>(const Success(AppThemeMode.system));
    provideDummy<Result<void>>(const Success<void>(null));
  });

  setUp(() {
    repository = MockThemeRepository();
    cubit = ThemeCubit(repository);
  });

  tearDown(() => cubit.close());

  test('starts at ThemeMode.system without side effects', () {
    expect(cubit.state, ThemeMode.system);
    verifyZeroInteractions(repository);
  });

  test('loadTheme emits the persisted theme', () async {
    when(repository.fetch())
        .thenAnswer((_) async => const Success(AppThemeMode.dark));

    await cubit.loadTheme();

    expect(cubit.state, ThemeMode.dark);
    verify(repository.fetch()).called(1);
  });

  test('setTheme persists then emits', () async {
    when(repository.save(any))
        .thenAnswer((_) async => const Success<void>(null));

    await cubit.setTheme(ThemeMode.light);

    expect(cubit.state, ThemeMode.light);
    verify(repository.save(AppThemeMode.light)).called(1);
  });
}
