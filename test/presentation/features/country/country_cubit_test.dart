import 'package:flutter_clean_bloc/domain/core/app_error.dart';
import 'package:flutter_clean_bloc/domain/core/result.dart';
import 'package:flutter_clean_bloc/domain/entities/country.dart';
import 'package:flutter_clean_bloc/domain/use_cases/country/country_use_case.dart';
import 'package:flutter_clean_bloc/presentation/features/country/country_cubit.dart';
import 'package:flutter_clean_bloc/presentation/features/country/country_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'country_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CountryUseCase>()])
void main() {
  late MockCountryUseCase useCase;
  late CountryCubit cubit;

  setUp(() {
    useCase = MockCountryUseCase();
    cubit = CountryCubit(useCase);
  });

  tearDown(() => cubit.close());

  test('starts in initial state without side effects', () {
    expect(cubit.state, const CountryState.initial());
    verifyZeroInteractions(useCase);
  });

  test('loadCountries emits [loading, data] on success', () async {
    final countries = [
      Country(name: CountryName(common: 'Vietnam')),
    ];
    final expected = Success(countries);
    provideDummy<Result<List<Country>>>(expected);
    when(useCase.fetchAllCountries()).thenAnswer((_) async => expected);

    final future = expectLater(
      cubit.stream,
      emitsInOrder([
        const CountryState.loading(),
        CountryState.data(countries),
      ]),
    );

    await cubit.loadCountries();
    await future;
  });

  test('loadCountries emits [loading, error(AppError)] on failure', () async {
    final expected = Failure(const NetworkError());
    provideDummy<Result<List<Country>>>(expected);
    when(useCase.fetchAllCountries()).thenAnswer((_) async => expected);

    final future = expectLater(
      cubit.stream,
      emitsInOrder([
        const CountryState.loading(),
        const CountryState.error(NetworkError()),
      ]),
    );

    await cubit.loadCountries();
    await future;
  });

  test('failure state carries the typed AppError, not a string', () async {
    final expected = Failure(const ServerError(statusCode: 500));
    provideDummy<Result<List<Country>>>(expected);
    when(useCase.fetchAllCountries()).thenAnswer((_) async => expected);

    await cubit.loadCountries();

    final state = cubit.state;
    state.maybeWhen(
      error: (error) => expect(error, isA<ServerError>()),
      orElse: () => fail('Expected error state'),
    );
  });
}
