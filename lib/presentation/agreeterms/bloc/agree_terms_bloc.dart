import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'agree_terms.dart';

class AgreeTermsBloc extends Bloc<AgreeTermsEvent, AgreeTermsState>
    with SideEffectBlocMixin<AgreeTermsEvent, AgreeTermsState, AgreeTermsSideEffect> {
  static const tag = "[PhoneNumberBloc]";

  AgreeTermsBloc() : super(AgreeTermsState.initial()) {
    on<AgreeTermsInit>(init);
    on<AgreeTermsTermClick>(onTermsClick);
    on<AgreeTermsAllClick>(onAllTermsClick);
  }

  FutureOr<void> init(AgreeTermsInit event, Emitter<AgreeTermsState> emit) {
    emit(
      AgreeTermsState.initial(
        event.agreeTerms,
        event.phoneNumber,
      ),
    );
  }

  FutureOr<void> onTermsClick(AgreeTermsTermClick event, Emitter<AgreeTermsState> emit) {
    final updatedAgreeTerms = state.agreeTerms.map((term) {
      if (event.terms != term) return term;
      return term.copyWith(isChecked: !term.isChecked);
    }).toList();
    emit(state.copyWith(agreeTerms: updatedAgreeTerms));
  }

  FutureOr<void> onAllTermsClick(AgreeTermsAllClick event, Emitter<AgreeTermsState> emit) async {
    for (var element in state.agreeTerms) {
      final updatedAgreeTerms = state.agreeTerms.map((term) {
        if (element != term) return term;
        return term.copyWith(isChecked: true);
      }).toList();
      emit(state.copyWith(agreeTerms: updatedAgreeTerms));
      await Future.delayed(const Duration(milliseconds: 100));
      final unCheckedTerms = state.agreeTerms.where((element) => !element.isChecked);
      // if (unCheckedTerms.isEmpty) {
      //   await authRepository
      //       .agreeTerms(
      //         phoneNumber: state.phoneNumber,
      //       )
      //       .then(
      //         (value) => value.fold(
      //           (l) => produceSideEffect(AgreeTermsError(l)),
      //           (r) => produceSideEffect(AgreeTermsPop(true)),
      //         ),
      //       );
      // }
    }
  }
}
