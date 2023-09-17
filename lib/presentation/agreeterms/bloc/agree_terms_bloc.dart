import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/supabase/usecase/get_terms_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'agree_terms.dart';

class AgreeTermsBloc extends Bloc<AgreeTermsEvent, AgreeTermsState>
    with SideEffectBlocMixin<AgreeTermsEvent, AgreeTermsState, AgreeTermsSideEffect> {
  final GetTermsUseCase getTermsUseCase;

  static const tag = "[PhoneNumberBloc]";

  AgreeTermsBloc({
    required this.getTermsUseCase,
  }) : super(AgreeTermsState.initial()) {
    on<AgreeTermsInit>(init);
    on<AgreeTermsTermClick>(onTermsClick);
    on<AgreeTermsAllClick>(onAllTermsClick);
  }

  FutureOr<void> init(AgreeTermsInit event, Emitter<AgreeTermsState> emit) async {
    final terms = await getTermsUseCase().then((value) => value.getOrElse(() => List.empty()));
    emit(
      AgreeTermsState.initial(
        terms,
        event.phoneNumber,
      ),
    );
  }

  FutureOr<void> onTermsClick(AgreeTermsTermClick event, Emitter<AgreeTermsState> emit) {
    AppMetrica.reportEvent('약관 개별 동의');
    final updatedAgreeTerms = state.agreeTerms.map((term) {
      if (event.terms != term) return term;
      return term.copyWith(isChecked: !term.isChecked);
    }).toList();
    emit(state.copyWith(agreeTerms: updatedAgreeTerms));
  }

  FutureOr<void> onAllTermsClick(AgreeTermsAllClick event, Emitter<AgreeTermsState> emit) async {
    AppMetrica.reportEvent('약관 모두 동의');
    for (var element in state.agreeTerms) {
      final updatedAgreeTerms = state.agreeTerms.map((term) {
        if (element != term) return term;
        return term.copyWith(isChecked: true);
      }).toList();
      emit(state.copyWith(agreeTerms: updatedAgreeTerms));
      await Future.delayed(const Duration(milliseconds: 100));
      final unCheckedTerms = state.agreeTerms.where((element) => !element.isChecked);
      if (unCheckedTerms.isEmpty) {
        produceSideEffect(AgreeTermsPop(true));
      }
    }
  }
}
