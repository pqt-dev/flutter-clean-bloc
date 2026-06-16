import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/core/result.dart';
import '../../../domain/use_cases/country/country_use_case.dart';
import 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  final CountryUseCase _useCase;

  CountryCubit(this._useCase) : super(const CountryState.initial());

  Future<void> loadCountries({bool forceRefresh = false}) async {
    emit(const CountryState.loading());
    final result = await _useCase.fetchAllCountries(forceRefresh: forceRefresh);
    if (isClosed) return;
    switch (result) {
      case Success(:final value):
        emit(CountryState.data(value));
      case Failure(:final error):
        emit(CountryState.error(error));
    }
  }
}
