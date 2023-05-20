import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_product_entity.dart';
import 'package:foresh_flutter/domain/usecases/obtain_reward_products_usecase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'reward_list.dart';

class RewardListBloc extends Bloc<RewardListEvent, RewardListState>
    with SideEffectBlocMixin<RewardListEvent, RewardListState, RewardListSideEffect> {
  static const _tag = "[RewardListBloc]";

  final ObtainRewardProductsUseCase obtainRewardProductsUseCase;

  RewardListBloc({
    required this.obtainRewardProductsUseCase,
  }) : super(RewardListState.initial()) {
    on<RewardListInit>(init);
    on<RewardListChangeCheckStatus>(changeCheckStatus);
    on<RewardListNextPage>(nextPage);
  }

  FutureOr<void> init(RewardListInit event, Emitter<RewardListState> emit) async {
    await obtainRewardProductsUseCase(0).then(
      (value) => value.fold(
        (l) => produceSideEffect(RewardListError(l)),
        (r) async {
          await Future.delayed(const Duration(milliseconds: 350));
          emit(
            state.copyWith(
              totalMarkerCount: r.totalMarkerCount,
              markers: r.markers,
              rewards: r.rewards,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> nextPage(RewardListNextPage event, Emitter<RewardListState> emit) async {
    if (!state.isNextPageLoading) {
      emit(
        state.copyWith(
          rewards: [...state.rewards, RewardProductLoading()],
          isNextPageLoading: true,
        ),
      );
      final nextPage = state.page + 1;
      await obtainRewardProductsUseCase(nextPage).then(
        (value) => value.fold(
          (l) {
            emit(
              state.copyWith(
                isLoading: false,
                isNextPageLoading: false,
              ),
            );
            produceSideEffect(RewardListError(l));
          },
          (r) async {
            final filteredItems = state.rewards.where((item) => item is! RewardProductLoading).toList();
            // 뷰스테이트가 로딩 상태로 바뀌기전까지 1초정도 딜레이를 줌.
            await Future.delayed(const Duration(milliseconds: 1000));
            emit(
              state.copyWith(
                rewards: List.of(filteredItems)..addAll(r.rewards),
                page: () {
                  // 다음 페이지가 비어 있으면 현재 페이지 넘버를 유지.
                  if (r.rewards.isEmpty) {
                    return state.page;
                  } else {
                    return nextPage;
                  }
                }(),
                isNextPageLoading: false,
              ),
            );
          },
        ),
      );
    }
  }

  FutureOr<void> changeCheckStatus(RewardListChangeCheckStatus event, Emitter<RewardListState> emit) {
    emit(state.copyWith(isChangeableChecked: !state.isChangeableChecked));
  }
}
