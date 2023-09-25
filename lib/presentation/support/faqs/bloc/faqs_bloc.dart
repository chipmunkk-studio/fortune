import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/supabase/usecase/get_faqs_usecase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'faqs.dart';

class FaqsBloc extends Bloc<FaqsEvent, FaqsState> with SideEffectBlocMixin<FaqsEvent, FaqsState, FaqsSideEffect> {
  final GetFaqsUseCase getFaqsUseCase;

  FaqsBloc({
    required this.getFaqsUseCase,
  }) : super(FaqsState.initial()) {
    on<FaqInit>(init);
  }

  FutureOr<void> init(FaqInit event, Emitter<FaqsState> emit) async {
    await getFaqsUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(FaqError(l)),
        (r) async {
          await Future.delayed(const Duration(microseconds: 200));
          emit(
            state.copyWith(
              items: r,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }
}
