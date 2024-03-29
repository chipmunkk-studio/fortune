import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/supabase/usecase/get_country_info_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'country_code.dart';

class CountryCodeBloc extends Bloc<CountryCodeEvent, CountryCodeState>
    with SideEffectBlocMixin<CountryCodeEvent, CountryCodeState, CountryCodeSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final GetCountryInfoUseCase getCountryInfoUseCase;

  CountryCodeBloc({
    required this.getCountryInfoUseCase,
  }) : super(CountryCodeState.initial()) {
    on<CountryCodeInit>(init);
  }

  FutureOr<void> init(CountryCodeInit event, Emitter<CountryCodeState> emit) async {
    await getCountryInfoUseCase().then(
      (value) => value.fold(
        (l) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(CountryCodeError(l));
        },
        (r) async {
          final selected = r.firstWhere(
            (element) => element.phoneCode == event.code,
          );
          emit(
            state.copyWith(
              countries: r,
              isLoading: false,
              selected: selected,
            ),
          );

          produceSideEffect(
            CountryCodeScrollSelected(
              state.countries.indexWhere(
                (element) => element.phoneCode == state.selected.phoneCode,
              ),
            ),
          );
        },
      ),
    );
  }
}
