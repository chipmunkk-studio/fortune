import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/entities/common/announcement_entity.dart';
import 'package:foresh_flutter/domain/usecases/obtain_announcement_usecaase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'announcement.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState>
    with SideEffectBlocMixin<AnnouncementEvent, AnnouncementState, AnnouncementSideEffect> {
  static const tag = "[AnnouncementBloc]";

  final ObtainAnnouncementUseCase obtainAnnouncementUseCase;

  AnnouncementBloc({
    required this.obtainAnnouncementUseCase,
  }) : super(AnnouncementState.initial()) {
    on<AnnouncementInit>(init);
    on<AnnouncementNextPage>(nextPage);
  }

  FutureOr<void> init(AnnouncementInit event, Emitter<AnnouncementState> emit) async {
    await obtainAnnouncementUseCase(0).then(
      (value) => value.fold(
        (l) => produceSideEffect(AnnouncementError(l)),
        (r) {
          emit(
            state.copyWith(
              items: r.notices,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> nextPage(AnnouncementNextPage event, Emitter<AnnouncementState> emit) async {
    if (!state.isNextPageLoading) {
      emit(
        state.copyWith(
          items: [...state.items, AnnouncementContentNextPageLoading()],
          isNextPageLoading: true,
        ),
      );
      final nextPage = state.page + 1;
      await obtainAnnouncementUseCase(nextPage).then(
        (value) => value.fold(
          (l) {
            emit(
              state.copyWith(
                isLoading: false,
                isNextPageLoading: false,
              ),
            );
            produceSideEffect(AnnouncementError(l));
          },
          (r) async {
            final filteredItems = state.items.where((item) => item is! AnnouncementContentNextPageLoading).toList();
            // 뷰스테이트가 로딩 상태로 바뀌기전까지 1초정도 딜레이를 줌.
            await Future.delayed(const Duration(milliseconds: 1000));
            emit(
              state.copyWith(
                items: List.of(filteredItems)..addAll(r.notices),
                page: () {
                  // 다음 페이지가 비어 있으면 현재 페이지 넘버를 유지.
                  if (r.notices.isEmpty) {
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
