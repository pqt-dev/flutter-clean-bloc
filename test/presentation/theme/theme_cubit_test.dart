import 'package:flutter/material.dart';
import 'package:flutter_clean_bloc/domain/core/app_theme_mode.dart';
import 'package:flutter_clean_bloc/domain/use_cases/theme/theme_use_case.dart';
import 'package:flutter_clean_bloc/presentation/theme/theme_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'theme_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ThemeUseCase>()])
void main() {
  late MockThemeUseCase useCase;
  late ThemeCubit cubit;

  setUp(() {
    useCase = MockThemeUseCase();
    cubit = ThemeCubit(useCase);
  });

  tearDown(() => cubit.close());

  test('starts at ThemeMode.system without side effects', () {
    expect(cubit.state, ThemeMode.system);
    verifyZeroInteractions(useCase);
  });

  test('loadTheme emits the persisted theme', () async {
    when(useCase.fetch()).thenAnswer((_) async => AppThemeMode.dark);

    await cubit.loadTheme();

    expect(cubit.state, ThemeMode.dark);
    verify(useCase.fetch()).called(1);
  });

  test('setTheme persists then emits', () async {
    when(useCase.save(any)).thenAnswer((_) async {});

    await cubit.setTheme(ThemeMode.light);

    expect(cubit.state, ThemeMode.light);
    verify(useCase.save(AppThemeMode.light)).called(1);
  });
}
