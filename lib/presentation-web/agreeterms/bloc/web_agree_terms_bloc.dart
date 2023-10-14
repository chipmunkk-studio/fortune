import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/supabase/usecase/get_terms_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'web_agree_terms.dart';

class WebAgreeTermsBloc extends Bloc<WebAgreeTermsEvent, WebAgreeTermsState>
    with SideEffectBlocMixin<WebAgreeTermsEvent, WebAgreeTermsState, WebAgreeTermsSideEffect> {
  final GetTermsUseCase getTermsUseCase;

  static const tag = "[PhoneNumberBloc]";

  WebAgreeTermsBloc({
    required this.getTermsUseCase,
  }) : super(WebAgreeTermsState.initial()) {
    on<WebAgreeTermsInit>(init);
    on<WebAgreeTermsTermClick>(onTermsClick);
    on<WebAgreeTermsAllClick>(onAllTermsClick);
  }

  FutureOr<void> init(WebAgreeTermsInit event, Emitter<WebAgreeTermsState> emit) async {
    final terms = await getTermsUseCase().then((value) => value.getOrElse(() => List.empty()));
    emit(
      WebAgreeTermsState.initial(
        terms,
        event.phoneNumber,
      ),
    );
  }

  FutureOr<void> onTermsClick(WebAgreeTermsTermClick event, Emitter<WebAgreeTermsState> emit) {
    final updatedAgreeTerms = state.agreeTerms.map((term) {
      if (event.terms != term) return term;
      return term.copyWith(isChecked: !term.isChecked);
    }).toList();
    emit(state.copyWith(agreeTerms: updatedAgreeTerms));
  }

  FutureOr<void> onAllTermsClick(WebAgreeTermsAllClick event, Emitter<WebAgreeTermsState> emit) async {
    for (var element in state.agreeTerms) {
      final updatedAgreeTerms = state.agreeTerms.map((term) {
        if (element != term) return term;
        return term.copyWith(isChecked: true);
      }).toList();
      emit(state.copyWith(agreeTerms: updatedAgreeTerms));
      await Future.delayed(const Duration(milliseconds: 100));
      final unCheckedTerms = state.agreeTerms.where((element) => !element.isChecked);
      if (unCheckedTerms.isEmpty) {
        produceSideEffect(WebAgreeTermsPop(true));
        return;
      }
    }
  }
}
