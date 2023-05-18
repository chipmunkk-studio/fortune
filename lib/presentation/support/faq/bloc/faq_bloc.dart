import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/entities/common/faq_entity.dart';
import 'package:foresh_flutter/domain/usecases/obtain_faq_usecaase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'faq.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> with SideEffectBlocMixin<FaqEvent, FaqState, FaqSideEffect> {
  static const tag = "[SupportBloc]";

  final ObtainFaqUseCase obtainFaqUseCase;

  FaqBloc({
    required this.obtainFaqUseCase,
  }) : super(FaqState.initial()) {
    on<FaqInit>(init);
    on<FaqNextPage>(nextPage);
  }

  FutureOr<void> init(FaqInit event, Emitter<FaqState> emit) async {
    await obtainFaqUseCase(0).then(
      (value) => value.fold(
        (l) => produceSideEffect(FaqError(l)),
        (r) {
          emit(
            state.copyWith(
              items: r.faqs,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> nextPage(FaqNextPage event, Emitter<FaqState> emit) async {
    if (!state.isNextPageLoading) {
      emit(
        state.copyWith(
          items: [...state.items, FaqContentNextPageLoading()],
          isNextPageLoading: true,
        ),
      );
      final nextPage = state.page + 1;
      await obtainFaqUseCase(nextPage).then(
        (value) => value.fold(
          (l) {
            emit(
              state.copyWith(
                isLoading: false,
                isNextPageLoading: false,
              ),
            );
            produceSideEffect(FaqError(l));
          },
          (r) async {
            final filteredItems = state.items.where((item) => item is! FaqContentNextPageLoading).toList();
            // 뷰스테이트가 로딩 상태로 바뀌기전까지 1초정도 딜레이를 줌.
            await Future.delayed(const Duration(milliseconds: 1000));
            emit(
              state.copyWith(
                items: List.of(filteredItems)..addAll(r.faqs),
                page: () {
                  // 다음 페이지가 비어 있으면 현재 페이지 넘버를 유지.
                  if (r.faqs.isEmpty) {
                    return state.page;
                  } else {
                    return nextPage;
                  }
                }(),
                isLoading: false,
                isNextPageLoading: false,
              ),
            );
          },
        ),
      );
    }
  }
}
