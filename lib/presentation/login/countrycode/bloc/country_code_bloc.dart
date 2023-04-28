import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/domain/usecases/obtain_country_code_usecase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../../domain/entities/country_code_entity.dart';
import 'country_code.dart';

class CountryCodeBloc extends Bloc<CountryCodeEvent, CountryCodeState>
    with SideEffectBlocMixin<CountryCodeEvent, CountryCodeState, CountryCodeSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final ObtainCountryCodeUseCase obtainCountryCodeUseCase;

  CountryCodeBloc({
    required this.obtainCountryCodeUseCase,
  }) : super(CountryCodeState.initial()) {
    on<CountryCodeInit>(init);
  }

  FutureOr<void> init(CountryCodeInit event, Emitter<CountryCodeState> emit) async {
    await obtainCountryCodeUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(CountryCodeError(l)),
        (r) {
          FortuneLogger.debug("${r.countries}");
          emit(
            state.copyWith(
              countries: r.countries,
              selected: CountryCode(
                code: event.code ?? state.selected.code,
                name: event.name ?? state.selected.name,
              ),
            ),
          );
          produceSideEffect(
            CountryCodeScrollSelected(
              state.countries.indexWhere((element) => element.code == state.selected.code),
            ),
          );
        },
      ),
    );
  }
}
