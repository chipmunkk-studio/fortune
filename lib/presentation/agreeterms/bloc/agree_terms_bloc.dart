import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/supabase/repository/auth_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'agree_terms.dart';

class AgreeTermsBloc extends Bloc<AgreeTermsEvent, AgreeTermsState>
    with SideEffectBlocMixin<AgreeTermsEvent, AgreeTermsState, AgreeTermsSideEffect> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  static const tag = "[PhoneNumberBloc]";

  AgreeTermsBloc({
    required this.authRepository,
    required this.userRepository,
  }) : super(AgreeTermsState.initial()) {
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
      if (unCheckedTerms.isEmpty) {
        produceSideEffect(AgreeTermsPop(true));
      }
    }
  }
}
