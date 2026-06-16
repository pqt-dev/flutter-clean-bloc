import 'package:flutter_clean_bloc_skeleton/data/datasource/theme/theme_datasource.dart';
import 'package:flutter_clean_bloc_skeleton/data/repositories/theme/theme_repository_impl.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/app_error.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/app_theme_mode.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'theme_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ThemeDatasource>()])
void main() {
  late MockThemeDatasource datasource;
  late ThemeRepositoryImpl repository;

  setUpAll(() {
    provideDummy<Result<String?>>(const Success<String?>(null));
    provideDummy<Result<void>>(const Success<void>(null));
  });

  setUp(() {
    datasource = MockThemeDatasource();
    repository = ThemeRepositoryImpl(datasource);
  });

  AppThemeMode unwrap(Result<AppThemeMode> result) {
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => fail('expected Success, got Failure: $error'),
    };
  }

  group('fetch maps stored string to AppThemeMode', () {
    test('"light" -> AppThemeMode.light', () async {
      when(datasource.read()).thenAnswer((_) async => const Success('light'));
      expect(unwrap(await repository.fetch()), equals(AppThemeMode.light));
    });

    test('"dark" -> AppThemeMode.dark', () async {
      when(datasource.read()).thenAnswer((_) async => const Success('dark'));
      expect(unwrap(await repository.fetch()), equals(AppThemeMode.dark));
    });

    test('"system" -> AppThemeMode.system', () async {
      when(datasource.read()).thenAnswer((_) async => const Success('system'));
      expect(unwrap(await repository.fetch()), equals(AppThemeMode.system));
    });

    test('null -> AppThemeMode.system', () async {
      when(datasource.read())
          .thenAnswer((_) async => const Success<String?>(null));
      expect(unwrap(await repository.fetch()), equals(AppThemeMode.system));
    });

    test('unknown value -> AppThemeMode.system', () async {
      when(datasource.read()).thenAnswer((_) async => const Success('weird'));
      expect(unwrap(await repository.fetch()), equals(AppThemeMode.system));
    });

    test('propagates Failure from datasource', () async {
      when(datasource.read())
          .thenAnswer((_) async => const Failure(UnexpectedError()));
      expect(await repository.fetch(), isA<Failure>());
    });
  });

  group('save maps AppThemeMode to its name string', () {
    test('writes "dark" for AppThemeMode.dark', () async {
      when(datasource.write(any))
          .thenAnswer((_) async => const Success<void>(null));

      final result = await repository.save(AppThemeMode.dark);

      expect(result, isA<Success>());
      verify(datasource.write('dark')).called(1);
    });

    test('propagates Failure from datasource', () async {
      when(datasource.write(any))
          .thenAnswer((_) async => const Failure(UnexpectedError()));

      expect(await repository.save(AppThemeMode.light), isA<Failure>());
    });
  });
}
