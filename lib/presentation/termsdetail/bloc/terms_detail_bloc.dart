import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_terms_by_index_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'terms_detail.dart';

class TermsDetailBloc extends Bloc<TermsDetailEvent, TermsDetailState>
    with SideEffectBlocMixin<TermsDetailEvent, TermsDetailState, TermsDetailSideEffect> {
  final GetTermsByIndexUseCase getTermsByIndexUseCase;

  TermsDetailBloc({
    required this.getTermsByIndexUseCase,
  }) : super(TermsDetailState.initial()) {
    on<TermsDetailInit>(init);
  }

  FutureOr<void> init(TermsDetailInit event, Emitter<TermsDetailState> emit) async {
    await getTermsByIndexUseCase(event.index).then(
      (value) => value.fold(
        (l) => produceSideEffect(TermsDetailError(l)),
        (r) {
          emit(state.copyWith(terms: r));
        },
      ),
    );
  }
}
